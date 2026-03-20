import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../../data/datasources/remote/report_remote_data_source.dart';
import '../../../data/models/post_models.dart';
import '../../router/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/marketplace_product_preview_provider.dart';
import '../../providers/reels_feed_provider.dart';
import '../../widgets/common/error_snackbar.dart';
import '../../widgets/reels/comments_bottom_sheet.dart';

const int _maxCaptionLength = 500;
const int _maxReportDescriptionLength = 400;

class ReelsFeedScreen extends ConsumerStatefulWidget {
	const ReelsFeedScreen({super.key});

	@override
	ConsumerState<ReelsFeedScreen> createState() => _ReelsFeedScreenState();
}

class _ReelsFeedScreenState extends ConsumerState<ReelsFeedScreen> {
	final PageController _pageController = PageController();
	int _currentIndex = 0;
	int _lastPrimedIndex = -1;

	void _primeVideoPreload(List<PostModel> posts, int index) {
		if (posts.isEmpty || index < 0 || index >= posts.length) {
			return;
		}

		if (_lastPrimedIndex == index) {
			return;
		}
		_lastPrimedIndex = index;

		final urlsToKeep = <String>{};
		for (var i = index; i <= index + 2; i++) {
			if (i >= posts.length) {
				break;
			}

			final url = posts[i].videoUrl;
			if (url == null || url.isEmpty) {
				continue;
			}

			urlsToKeep.add(url);
			if (i > index) {
				_ReelsVideoPreloadCache.preload(url);
			}
		}

		_ReelsVideoPreloadCache.prune(keepUrls: urlsToKeep);
	}

	@override
	void dispose() {
		_ReelsVideoPreloadCache.disposeAll();
		_pageController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final state = ref.watch(reelsFeedProvider);
		final isAuthenticated = ref.watch(isAuthenticatedProvider);

		if (state.posts.isNotEmpty) {
			_primeVideoPreload(state.posts, _currentIndex.clamp(0, state.posts.length - 1));
		}

		if (state.isInitialLoading && state.posts.isEmpty) {
			return const Scaffold(
				body: Center(child: CircularProgressIndicator()),
			);
		}

		if (state.posts.isEmpty) {
			return Scaffold(
				appBar: AppBar(title: const Text('Reels')),
				body: Center(
					child: Column(
						mainAxisSize: MainAxisSize.min,
						children: <Widget>[
							const Text('Aucun reel disponible pour le moment.'),
							const SizedBox(height: 12),
							FilledButton(
								onPressed: () => ref.read(reelsFeedProvider.notifier).loadInitial(),
								child: const Text('Reessayer'),
							),
						],
					),
				),
			);
		}

		return Scaffold(
			body: Stack(
				children: <Widget>[
					RefreshIndicator(
						onRefresh: () => ref.read(reelsFeedProvider.notifier).refresh(),
						child: PageView.builder(
							controller: _pageController,
							scrollDirection: Axis.vertical,
							itemCount: state.posts.length,
							onPageChanged: (int index) {
								setState(() {
									_currentIndex = index;
								});
									_primeVideoPreload(state.posts, index);
								final threshold = state.posts.length - 2;
								if (index >= threshold) {
									ref.read(reelsFeedProvider.notifier).loadMore();
								}
							},
							itemBuilder: (BuildContext context, int index) {
								final post = state.posts[index];
								return _ReelPage(
									key: ValueKey<String>(post.id),
									post: post,
									isActive: _currentIndex == index,
									takePreloadedController: _ReelsVideoPreloadCache.take,
									onLikeTap: () => ref.read(reelsFeedProvider.notifier).toggleLike(post),
									onProductTap: () async {
										final productUid = post.marketplaceProductUid;
										if (productUid == null || productUid.isEmpty) {
											if (mounted) {
												showErrorSnackbar(context, 'Aucun produit lie a ce reel.');
											}
											return;
										}

										context.push('/marketplace/$productUid');
									},
									onShareTap: () async {
										final text = _buildShareText(post);
										if (text.isEmpty) {
											if (mounted) {
												showErrorSnackbar(context, 'Contenu indisponible pour le partage.');
											}
											return;
										}

										await Share.share(text);
										if (!mounted) {
											return;
										}
										ref.read(reelsFeedProvider.notifier).applySharesCountDelta(post.id, 1);
									},
									onCartTap: () async {
										if (!isAuthenticated) {
											await showAuthRequiredSheet(context);
											return;
										}

										final productUid = post.marketplaceProductUid;
										if (productUid != null && productUid.isNotEmpty) {
											context.push('/marketplace/$productUid');
											return;
										}

										context.push(AppRoutes.cart);
									},
									onCommentTap: () async {
										if (!isAuthenticated) {
											await showAuthRequiredSheet(context);
											return;
										}

										final commentsDelta = await showCommentsBottomSheet(
											context,
											post: post,
										);

										if (!mounted || commentsDelta == null || commentsDelta == 0) {
											return;
										}

										ref.read(reelsFeedProvider.notifier).applyCommentsCountDelta(post.id, commentsDelta);
									},
									onProfileTap: () {
										final userId = post.userId.trim();
										if (!_isValidProfileUserId(userId)) {
											showErrorSnackbar(context, 'Profil createur indisponible pour ce reel.');
											return;
										}

										context.push(
											AppRoutes.userProfile.replaceFirst(':userId', userId),
										);
									},
								);
							},
						),
					),
					SafeArea(
						child: Padding(
							padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
							child: Row(
								children: const <Widget>[
									Text(
										'Reels',
										style: TextStyle(
											color: Colors.white,
											fontSize: 18,
											fontWeight: FontWeight.w700,
										),
									),
								],
							),
						),
					),
					if (state.isPaginating)
						const Positioned(
							bottom: 28,
							left: 0,
							right: 0,
							child: Center(child: CircularProgressIndicator()),
						),
				],
			),
		);
	}

	bool _isValidProfileUserId(String userId) {
		if (userId.isEmpty) {
			return false;
		}

		const invalidValues = <String>{'unknown_user', 'unknown', 'null'};
		return !invalidValues.contains(userId.toLowerCase());
	}
}

class _ReelPage extends ConsumerWidget {
	const _ReelPage({
		super.key,
		required this.post,
		required this.isActive,
		required this.takePreloadedController,
		required this.onLikeTap,
		required this.onProductTap,
		required this.onShareTap,
		required this.onCartTap,
		required this.onCommentTap,
		required this.onProfileTap,
	});

	final PostModel post;
	final bool isActive;
	final VideoPlayerController? Function(String url) takePreloadedController;
	final VoidCallback onLikeTap;
	final Future<void> Function() onProductTap;
	final Future<void> Function() onShareTap;
	final Future<void> Function() onCartTap;
	final Future<void> Function() onCommentTap;
	final VoidCallback onProfileTap;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final productUid = post.marketplaceProductUid;
		final productPreviewAsync =
				productUid?.isNotEmpty == true ? ref.watch(marketplaceProductPreviewProvider(productUid!)) : null;
		final isOwner = ref.watch(currentUserProvider)?.id == post.userId;

		return GestureDetector(
			onLongPress: () async {
				await _showLongPressContextMenu(context, ref, isOwner: isOwner);
			},
			child: Stack(
				fit: StackFit.expand,
				children: <Widget>[
				_VideoSurface(
					post: post,
					isActive: isActive,
					takePreloadedController: takePreloadedController,
				),
				DecoratedBox(
					decoration: const BoxDecoration(
						gradient: LinearGradient(
							begin: Alignment.topCenter,
							end: Alignment.bottomCenter,
							colors: <Color>[Colors.transparent, Colors.black54],
						),
					),
				),
				Positioned(
					left: 16,
					right: 84,
					bottom: 24,
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						mainAxisSize: MainAxisSize.min,
						children: <Widget>[
							GestureDetector(
								onTap: onProfileTap,
								child: Text(
									'@${post.username}',
									style: const TextStyle(
										color: Colors.white,
										fontWeight: FontWeight.w700,
										fontSize: 16,
									),
								),
							),
							const SizedBox(height: 8),
							Text(
								post.caption?.trim().isNotEmpty == true
										? post.caption!.trim()
										: 'Aucune description',
								style: const TextStyle(color: Colors.white),
								maxLines: 2,
								overflow: TextOverflow.ellipsis,
							),
							if (post.marketplaceProductUid?.isNotEmpty == true) ...<Widget>[
								const SizedBox(height: 12),
								GestureDetector(
									onTap: () async {
										try {
											await onProductTap();
										} catch (_) {
											if (context.mounted) {
												showErrorSnackbar(context, 'Produit indisponible pour le moment.');
											}
										}
									},
									child: Container(
										padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
										decoration: BoxDecoration(
											color: Colors.black.withValues(alpha: 0.35),
											borderRadius: BorderRadius.circular(14),
											border: Border.all(color: Colors.white24),
										),
										child: _buildProductOverlayContent(productPreviewAsync),
									),
								),
							],
						],
					),
				),
				if (isOwner)
					Positioned(
						top: 56,
						right: 14,
						child: Container(
							decoration: BoxDecoration(
								color: Colors.black.withValues(alpha: 0.35),
								shape: BoxShape.circle,
							),
							child: IconButton(
								onPressed: () async {
									await _showOwnerActions(context, ref);
								},
								icon: const Icon(Icons.more_vert, color: Colors.white),
							),
						),
					),
				Positioned(
					right: 14,
					bottom: 30,
					child: Column(
						mainAxisSize: MainAxisSize.min,
						children: <Widget>[
							IconButton(
								onPressed: onLikeTap,
								icon: Icon(
									post.isLiked ? Icons.favorite : Icons.favorite_border,
									color: post.isLiked ? Colors.redAccent : Colors.white,
									size: 30,
								),
							),
							Text(
								'${post.likesCount}',
								style: const TextStyle(color: Colors.white),
							),
							const SizedBox(height: 14),
							IconButton(
								onPressed: () async {
									try {
										await onCommentTap();
									} catch (_) {
										if (context.mounted) {
											showErrorSnackbar(context, 'Impossible d\'ouvrir les commentaires.');
										}
									}
								},
								icon: const Icon(Icons.comment_outlined, color: Colors.white, size: 28),
							),
							Text(
								'${post.commentsCount}',
								style: const TextStyle(color: Colors.white),
							),
							const SizedBox(height: 14),
							IconButton(
								onPressed: () async {
									try {
										await onShareTap();
									} catch (_) {
										if (context.mounted) {
											showErrorSnackbar(context, 'Impossible de partager ce reel.');
										}
									}
								},
								icon: const Icon(Icons.send_outlined, color: Colors.white, size: 28),
							),
							Text(
								'${post.sharesCount}',
								style: const TextStyle(color: Colors.white),
							),
							const SizedBox(height: 14),
							IconButton(
								onPressed: () async {
									try {
										await onCartTap();
									} catch (_) {
										if (context.mounted) {
											showErrorSnackbar(context, 'Action panier indisponible.');
										}
									}
								},
								icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28),
							),
						],
					),
				),
				],
			),
		);
	}

	Future<void> _showLongPressContextMenu(
		BuildContext context,
		WidgetRef ref, {
		required bool isOwner,
	}) async {
		final hasLinkedProduct = post.marketplaceProductUid?.isNotEmpty == true;

		final action = await showModalBottomSheet<String>(
			context: context,
			builder: (BuildContext modalContext) {
				return SafeArea(
					child: Column(
						mainAxisSize: MainAxisSize.min,
						children: <Widget>[
							const ListTile(
								leading: Icon(Icons.touch_app_outlined),
								title: Text('Actions rapides'),
							),
							ListTile(
								leading: const Icon(Icons.send_outlined),
								title: const Text('Partager ce reel'),
								onTap: () => Navigator.of(modalContext).pop('share'),
							),
							ListTile(
								leading: const Icon(Icons.comment_outlined),
								title: const Text('Ouvrir les commentaires'),
								onTap: () => Navigator.of(modalContext).pop('comments'),
							),
							if (hasLinkedProduct)
								ListTile(
									leading: const Icon(Icons.shopping_bag_outlined),
									title: const Text('Voir le produit'),
									onTap: () => Navigator.of(modalContext).pop('product'),
								),
							if (isOwner)
								ListTile(
									leading: const Icon(Icons.manage_accounts_outlined),
									title: const Text('Gerer ma publication'),
									onTap: () => Navigator.of(modalContext).pop('owner_actions'),
								)
							else
								ListTile(
									leading: const Icon(Icons.flag_outlined),
									title: const Text('Signaler ce reel'),
									onTap: () => Navigator.of(modalContext).pop('report'),
								),
						],
					),
				);
			},
		);

		if (action == null || !context.mounted) {
			return;
		}

		switch (action) {
			case 'share':
				await onShareTap();
				break;
			case 'comments':
				await onCommentTap();
				break;
			case 'product':
				await onProductTap();
				break;
			case 'owner_actions':
				await _showOwnerActions(context, ref);
				break;
			case 'report':
					await _reportPost(context, ref);
				break;
		}
	}

	Future<void> _reportPost(BuildContext context, WidgetRef ref) async {
		final isAuthenticated = ref.read(isAuthenticatedProvider);
		if (!isAuthenticated) {
			await showAuthRequiredSheet(context);
			return;
		}

		const reasons = <String>[
			'spam',
			'harassment',
			'inappropriate',
			'violence',
			'hate_speech',
			'misinformation',
			'other',
		];

		final selectedReason = await showModalBottomSheet<String>(
			context: context,
			builder: (BuildContext modalContext) {
				return SafeArea(
					child: ListView(
						shrinkWrap: true,
						children: <Widget>[
							const ListTile(
								leading: Icon(Icons.flag_outlined),
								title: Text('Choisir une raison de signalement'),
							),
							for (final reason in reasons)
								ListTile(
									leading: const Icon(Icons.chevron_right),
									title: Text(_formatReason(reason)),
									onTap: () => Navigator.of(modalContext).pop(reason),
								),
						],
					),
				);
			},
		);

		if (selectedReason == null || !context.mounted) {
			return;
		}

		final descriptionController = TextEditingController();
		final templates = _reportTemplatesForReason(selectedReason);
		final description = await showDialog<String>(
			context: context,
			builder: (BuildContext dialogContext) {
				String? selectedTemplate;

				return AlertDialog(
					title: const Text('Description (optionnelle)'),
					content: StatefulBuilder(
						builder: (BuildContext context, void Function(void Function()) setModalState) {
							return SingleChildScrollView(
								child: Column(
									mainAxisSize: MainAxisSize.min,
									crossAxisAlignment: CrossAxisAlignment.start,
									children: <Widget>[
										if (templates.isNotEmpty) ...<Widget>[
											const Text(
												'Templates rapides',
												style: TextStyle(fontWeight: FontWeight.w600),
											),
											const SizedBox(height: 8),
											Wrap(
												spacing: 8,
												runSpacing: 8,
												children: templates.map((template) {
													final selected = selectedTemplate == template;
													return ChoiceChip(
														label: Text(template),
														selected: selected,
														onSelected: (_) {
															setModalState(() {
																selectedTemplate = template;
																descriptionController.text = template;
																descriptionController.selection = TextSelection.fromPosition(
																	TextPosition(offset: descriptionController.text.length),
																);
															});
														},
													);
												}).toList(growable: false),
											),
											const SizedBox(height: 12),
										],
										TextField(
											controller: descriptionController,
											maxLines: 4,
											maxLength: _maxReportDescriptionLength,
											decoration: const InputDecoration(
												hintText: 'Ajoutez un contexte si necessaire...',
												helperText: 'Description optionnelle pour aider la moderation',
											),
										),
									],
								),
							);
						},
					),
					actions: <Widget>[
						TextButton(
							onPressed: () => Navigator.of(dialogContext).pop(''),
							child: const Text('Passer'),
						),
						FilledButton(
							onPressed: () => Navigator.of(dialogContext).pop(descriptionController.text.trim()),
							child: const Text('Envoyer'),
						),
					],
				);
			},
		);
		descriptionController.dispose();

		try {
			await ReportRemoteDataSource().createPostReport(
				postId: post.id,
				reason: selectedReason,
				description: description,
			);
			if (context.mounted) {
				showSuccessSnackbar(context, 'Signalement envoye. Merci pour votre vigilance.');
			}
		} catch (_) {
			if (context.mounted) {
				showErrorSnackbar(context, 'Impossible d\'envoyer le signalement pour le moment.');
			}
		}
	}

	List<String> _reportTemplatesForReason(String reason) {
		switch (reason) {
			case 'spam':
				return const <String>[
					'Contenu publicitaire repete et non sollicite.',
					'Publication automatique/flood detectee.',
				];
			case 'harassment':
				return const <String>[
					'Propos offensants visant une personne.',
					'Comportement de harcelement repete.',
				];
			case 'inappropriate':
				return const <String>[
					'Contenu choquant/inapproprie pour la plateforme.',
					'Langage explicitement inapproprie.',
				];
			case 'violence':
				return const <String>[
					'Incitation a la violence.',
					'Contenu violent explicite.',
				];
			case 'hate_speech':
				return const <String>[
					'Propos discriminatoires ou haineux.',
					'Attaque d\'un groupe protege.',
				];
			case 'misinformation':
				return const <String>[
					'Information potentiellement fausse/non verifiee.',
					'Contenu trompeur susceptible de nuire.',
				];
			default:
				return const <String>[
					'Autre motif de signalement.',
					'Contexte complementaire a verifier.',
				];
		}
	}

	String _formatReason(String reason) {
		switch (reason) {
			case 'hate_speech':
				return 'Discours haineux';
			case 'misinformation':
				return 'Desinformation';
			case 'harassment':
				return 'Harcèlement';
			case 'inappropriate':
				return 'Contenu inapproprie';
			case 'violence':
				return 'Violence';
			case 'spam':
				return 'Spam';
			default:
				return 'Autre';
		}
	}

	Future<void> _showOwnerActions(BuildContext context, WidgetRef ref) async {
		final action = await showModalBottomSheet<String>(
			context: context,
			builder: (BuildContext modalContext) {
				return SafeArea(
					child: Column(
						mainAxisSize: MainAxisSize.min,
						children: <Widget>[
							ListTile(
								leading: const Icon(Icons.edit_outlined),
								title: const Text('Modifier la publication'),
								onTap: () => Navigator.of(modalContext).pop('edit'),
							),
							ListTile(
								leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
								title: const Text(
									'Supprimer la publication',
									style: TextStyle(color: Colors.redAccent),
								),
								onTap: () => Navigator.of(modalContext).pop('delete'),
							),
						],
					),
				);
			},
		);

		if (action == null || !context.mounted) {
			return;
		}

		if (action == 'edit') {
			await _editPostCaption(context, ref);
			return;
		}

		if (action == 'delete') {
			final confirmed = await showDialog<bool>(
				context: context,
				builder: (BuildContext dialogContext) {
					return AlertDialog(
						title: const Text('Supprimer ce reel ?'),
						content: const Text('Cette action est irreversible.'),
						actions: <Widget>[
							TextButton(
								onPressed: () => Navigator.of(dialogContext).pop(false),
								child: const Text('Annuler'),
							),
							FilledButton(
								onPressed: () => Navigator.of(dialogContext).pop(true),
								child: const Text('Supprimer'),
							),
						],
					);
				},
			);

			if (confirmed == true) {
				await ref.read(reelsFeedProvider.notifier).deletePost(post.id);
				if (context.mounted) {
					showSuccessSnackbar(context, 'Publication supprimee.');
				}
			}
		}
	}

	Future<void> _editPostCaption(BuildContext context, WidgetRef ref) async {
		final controller = TextEditingController(text: post.caption ?? '');
		final nextCaption = await showDialog<String>(
			context: context,
			builder: (BuildContext dialogContext) {
				return AlertDialog(
					title: const Text('Modifier la description'),
					content: TextField(
						controller: controller,
						maxLines: 4,
						minLines: 2,
						maxLength: _maxCaptionLength,
						decoration: const InputDecoration(
							hintText: 'Ecrivez la nouvelle description...',
							helperText: 'Le texte est public sur votre reel',
						),
					),
					actions: <Widget>[
						TextButton(
							onPressed: () => Navigator.of(dialogContext).pop(),
							child: const Text('Annuler'),
						),
						FilledButton(
							onPressed: () => Navigator.of(dialogContext).pop(controller.text),
							child: const Text('Enregistrer'),
						),
					],
				);
			},
		);
		controller.dispose();

		if (nextCaption == null) {
			return;
		}

		if (!context.mounted) {
			return;
		}

		if (nextCaption.length > _maxCaptionLength) {
			showErrorSnackbar(context, 'Description trop longue (max $_maxCaptionLength caracteres).');
			return;
		}

		final ok = await ref.read(reelsFeedProvider.notifier).updatePostCaption(post.id, nextCaption);
		if (!context.mounted) {
			return;
		}

		if (ok) {
			showSuccessSnackbar(context, 'Description mise a jour.');
		} else {
			showErrorSnackbar(context, 'Impossible de modifier la description.');
		}
	}

	Widget _buildProductOverlayContent(AsyncValue<dynamic>? productPreviewAsync) {
		if (productPreviewAsync == null) {
			return const _ProductOverlayFallback();
		}

		return productPreviewAsync.when(
			data: (preview) {
				if (preview == null) {
					return const _ProductOverlayFallback();
				}

				final priceText = preview.price > 0
						? '${preview.price.toStringAsFixed(2)} ${preview.currency ?? ''}'.trim()
						: null;

				return Row(
					mainAxisSize: MainAxisSize.min,
					children: <Widget>[
						if (preview.imageUrl != null && preview.imageUrl!.isNotEmpty)
							ClipRRect(
								borderRadius: BorderRadius.circular(8),
								child: CachedNetworkImage(
									imageUrl: preview.imageUrl!,
									width: 34,
									height: 34,
									fit: BoxFit.cover,
									errorWidget: (_, __, ___) => const SizedBox(
										width: 34,
										height: 34,
										child: Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 16),
									),
								),
							)
						else
							const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 16),
						const SizedBox(width: 8),
						ConstrainedBox(
							constraints: const BoxConstraints(maxWidth: 170),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								mainAxisSize: MainAxisSize.min,
								children: <Widget>[
									Text(
										preview.name,
										maxLines: 1,
										overflow: TextOverflow.ellipsis,
										style: const TextStyle(
											color: Colors.white,
											fontWeight: FontWeight.w700,
										),
									),
									if (priceText != null)
										Text(
											priceText,
											style: const TextStyle(
												color: Colors.white70,
												fontWeight: FontWeight.w600,
												fontSize: 12,
											),
										),
								],
							),
						),
					],
				);
			},
			loading: () => const Row(
				mainAxisSize: MainAxisSize.min,
				children: <Widget>[
					SizedBox(
						height: 16,
						width: 16,
						child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
					),
					SizedBox(width: 8),
					Text(
						'Chargement produit...',
						style: TextStyle(color: Colors.white),
					),
				],
			),
			error: (_, __) => const _ProductOverlayFallback(),
		);
	}
}

class _ProductOverlayFallback extends StatelessWidget {
	const _ProductOverlayFallback();

	@override
	Widget build(BuildContext context) {
		return const Row(
			mainAxisSize: MainAxisSize.min,
			children: <Widget>[
				Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 16),
				SizedBox(width: 8),
				Text(
					'Voir le produit',
					style: TextStyle(
						color: Colors.white,
						fontWeight: FontWeight.w600,
					),
				),
			],
		);
	}
}

String _buildShareText(PostModel post) {
	final textParts = <String>[];

	if (post.caption?.trim().isNotEmpty == true) {
		textParts.add(post.caption!.trim());
	}

	if (post.videoUrl?.trim().isNotEmpty == true) {
		textParts.add(post.videoUrl!.trim());
	} else if (post.thumbnailUrl?.trim().isNotEmpty == true) {
		textParts.add(post.thumbnailUrl!.trim());
	}

	return textParts.join('\n');
}

class _VideoSurface extends StatefulWidget {
	const _VideoSurface({
		required this.post,
		required this.isActive,
		required this.takePreloadedController,
	});

	final PostModel post;
	final bool isActive;
	final VideoPlayerController? Function(String url)? takePreloadedController;

	@override
	State<_VideoSurface> createState() => _VideoSurfaceState();
}

class _VideoSurfaceState extends State<_VideoSurface> {
	VideoPlayerController? _controller;

	@override
	void initState() {
		super.initState();
		_initController();
	}

	@override
	void didUpdateWidget(covariant _VideoSurface oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (oldWidget.post.videoUrl != widget.post.videoUrl) {
			_disposeController();
			_initController();
			return;
		}

		if (_controller != null) {
			if (widget.isActive) {
				_controller!.play();
			} else {
				_controller!.pause();
			}
		}
	}

	@override
	void dispose() {
		_disposeController();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final videoUrl = widget.post.videoUrl;
		if (videoUrl == null || videoUrl.isEmpty || _controller == null) {
			return _buildImageFallback();
		}

		final controller = _controller!;
		if (!controller.value.isInitialized) {
			return Stack(
				fit: StackFit.expand,
				children: <Widget>[
					_buildImageFallback(),
					const Center(child: CircularProgressIndicator()),
				],
			);
		}

		return FittedBox(
			fit: BoxFit.cover,
			child: SizedBox(
				width: controller.value.size.width,
				height: controller.value.size.height,
				child: VideoPlayer(controller),
			),
		);
	}

	Widget _buildImageFallback() {
		if (widget.post.thumbnailUrl?.isNotEmpty == true) {
			return CachedNetworkImage(
				imageUrl: widget.post.thumbnailUrl!,
				fit: BoxFit.cover,
			);
		}

		return DecoratedBox(
			decoration: BoxDecoration(
				gradient: LinearGradient(
					begin: Alignment.topCenter,
					end: Alignment.bottomCenter,
					colors: <Color>[
						Colors.blueGrey.shade700,
						Colors.black,
					],
				),
			),
			child: const Center(
				child: Icon(Icons.play_circle_outline, color: Colors.white70, size: 80),
			),
		);
	}

	Future<void> _initController() async {
		final url = widget.post.videoUrl;
		if (url == null || url.isEmpty) {
			return;
		}

		final preloaded = widget.takePreloadedController?.call(url);
		if (preloaded != null) {
			_controller = preloaded;
			if (widget.isActive) {
				await preloaded.play();
			} else {
				await preloaded.pause();
			}
			if (mounted) {
				setState(() {});
			}
			return;
		}

		final controller = VideoPlayerController.networkUrl(Uri.parse(url));
		_controller = controller;

		try {
			await controller.initialize();
			await controller.setLooping(true);
			if (widget.isActive && mounted) {
				await controller.play();
			}
			if (mounted) {
				setState(() {});
			}
		} catch (_) {
			_disposeController();
			if (mounted) {
				setState(() {});
			}
		}
	}

	void _disposeController() {
		final controller = _controller;
		_controller = null;
		controller?.dispose();
	}
}

class _ReelsVideoPreloadCache {
	static final Map<String, VideoPlayerController> _cache =
			<String, VideoPlayerController>{};

	static Future<void> preload(String url) async {
		if (_cache.containsKey(url)) {
			return;
		}

		final controller = VideoPlayerController.networkUrl(Uri.parse(url));
		try {
			await controller.initialize();
			await controller.setLooping(true);
			await controller.pause();
			_cache[url] = controller;
		} catch (_) {
			controller.dispose();
		}
	}

	static VideoPlayerController? take(String url) {
		return _cache.remove(url);
	}

	static void prune({required Set<String> keepUrls}) {
		final toDispose = _cache.keys.where((url) => !keepUrls.contains(url)).toList();
		for (final url in toDispose) {
			_cache.remove(url)?.dispose();
		}
	}

	static void disposeAll() {
		for (final controller in _cache.values) {
			controller.dispose();
		}
		_cache.clear();
	}
}
