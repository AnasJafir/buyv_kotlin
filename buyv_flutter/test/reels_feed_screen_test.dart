import 'package:buyv/presentation/providers/auth_provider.dart';
import 'package:buyv/presentation/providers/marketplace_product_preview_provider.dart';
import 'package:buyv/presentation/providers/reel_comments_provider.dart';
import 'package:buyv/presentation/providers/reels_feed_provider.dart';
import 'package:buyv/presentation/screens/reels/reels_feed_screen.dart';
import 'package:buyv/data/models/auth_models.dart';
import 'package:buyv/data/models/post_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakeEmptyReelsFeedNotifier extends ReelsFeedNotifier {
  @override
  ReelsFeedState build() {
    return const ReelsFeedState(
      posts: <PostModel>[],
      isInitialLoading: false,
      hasMore: false,
      offset: 0,
    );
  }
}

class _FakeSinglePostReelsFeedNotifier extends ReelsFeedNotifier {
  @override
  ReelsFeedState build() {
    return const ReelsFeedState(
      posts: <PostModel>[
        PostModel(
          id: 'post-1',
          userId: 'user-1',
          username: 'alice',
          type: 'reel',
          caption: 'Mon premier reel',
          likesCount: 12,
          commentsCount: 3,
          sharesCount: 1,
          createdAt: '2026-01-01T00:00:00Z',
          updatedAt: '2026-01-01T00:00:00Z',
        ),
      ],
      isInitialLoading: false,
      hasMore: false,
      offset: 1,
    );
  }
}

class _SpyLikeReelsFeedNotifier extends ReelsFeedNotifier {
  static String? lastLikedPostId;

  @override
  ReelsFeedState build() {
    return const ReelsFeedState(
      posts: <PostModel>[
        PostModel(
          id: 'post-1',
          userId: 'user-1',
          username: 'alice',
          type: 'reel',
          caption: 'Mon premier reel',
          likesCount: 12,
          commentsCount: 3,
          sharesCount: 1,
          createdAt: '2026-01-01T00:00:00Z',
          updatedAt: '2026-01-01T00:00:00Z',
        ),
      ],
      isInitialLoading: false,
      hasMore: false,
      offset: 1,
    );
  }

  @override
  Future<void> toggleLike(PostModel post) async {
    lastLikedPostId = post.id;
  }
}

class _FakeShareUnavailableReelsFeedNotifier extends ReelsFeedNotifier {
  @override
  ReelsFeedState build() {
    return const ReelsFeedState(
      posts: <PostModel>[
        PostModel(
          id: 'post-no-share',
          userId: 'user-2',
          username: 'bob',
          type: 'reel',
          caption: null,
          videoUrl: null,
          thumbnailUrl: null,
          createdAt: '2026-01-01T00:00:00Z',
          updatedAt: '2026-01-01T00:00:00Z',
        ),
      ],
      isInitialLoading: false,
      hasMore: false,
      offset: 1,
    );
  }
}

class _FakeMarketplaceLinkedReelsFeedNotifier extends ReelsFeedNotifier {
  @override
  ReelsFeedState build() {
    return const ReelsFeedState(
      posts: <PostModel>[
        PostModel(
          id: 'post-linked',
          userId: 'user-3',
          username: 'charlie',
          type: 'reel',
          caption: 'Reel avec produit lie',
          marketplaceProductUid: 'prod-42',
          createdAt: '2026-01-01T00:00:00Z',
          updatedAt: '2026-01-01T00:00:00Z',
        ),
      ],
      isInitialLoading: false,
      hasMore: false,
      offset: 1,
    );
  }
}

class _FakeReelCommentsNotifier extends ReelCommentsNotifier {
  @override
  ReelCommentsState build(String postId) {
    return const ReelCommentsState(
      comments: <CommentModel>[],
      isLoading: false,
      isSubmitting: false,
    );
  }
}

void main() {
  testWidgets('Reels feed displays empty state when no posts are available', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          reelsFeedProvider.overrideWith(_FakeEmptyReelsFeedNotifier.new),
          isAuthenticatedProvider.overrideWithValue(false),
        ],
        child: const MaterialApp(
          home: ReelsFeedScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Reels'), findsOneWidget);
    expect(find.text('Aucun reel disponible pour le moment.'), findsOneWidget);
    expect(find.text('Reessayer'), findsOneWidget);
  });

  testWidgets('Reels feed renders a mocked post content and actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          reelsFeedProvider.overrideWith(_FakeSinglePostReelsFeedNotifier.new),
          isAuthenticatedProvider.overrideWithValue(false),
        ],
        child: const MaterialApp(
          home: ReelsFeedScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('@alice'), findsOneWidget);
    expect(find.text('Mon premier reel'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.comment_outlined), findsOneWidget);
    expect(find.byIcon(Icons.send_outlined), findsOneWidget);
  });

  testWidgets('Reels feed like button triggers toggleLike on notifier', (
    WidgetTester tester,
  ) async {
    _SpyLikeReelsFeedNotifier.lastLikedPostId = null;

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          reelsFeedProvider.overrideWith(_SpyLikeReelsFeedNotifier.new),
          isAuthenticatedProvider.overrideWithValue(false),
        ],
        child: const MaterialApp(
          home: ReelsFeedScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();

    expect(_SpyLikeReelsFeedNotifier.lastLikedPostId, 'post-1');
  });

  testWidgets('Guest tapping comment sees auth-required sheet', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          reelsFeedProvider.overrideWith(_FakeSinglePostReelsFeedNotifier.new),
          isAuthenticatedProvider.overrideWithValue(false),
        ],
        child: const MaterialApp(
          home: ReelsFeedScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.tap(find.byIcon(Icons.comment_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Sign in to continue'), findsOneWidget);
    expect(find.text('Continue Browsing'), findsOneWidget);
  });

  testWidgets('Guest tapping cart sees auth-required sheet', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          reelsFeedProvider.overrideWith(_FakeSinglePostReelsFeedNotifier.new),
          isAuthenticatedProvider.overrideWithValue(false),
        ],
        child: const MaterialApp(
          home: ReelsFeedScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Sign in to continue'), findsOneWidget);
    expect(find.text('Continue Browsing'), findsOneWidget);
  });

  testWidgets('Authenticated tapping comment opens comments bottom sheet', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          reelsFeedProvider.overrideWith(_FakeSinglePostReelsFeedNotifier.new),
          isAuthenticatedProvider.overrideWithValue(true),
          reelCommentsProvider.overrideWith(_FakeReelCommentsNotifier.new),
        ],
        child: const MaterialApp(
          home: ReelsFeedScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.tap(find.byIcon(Icons.comment_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Commentaires'), findsWidgets);
  });

  testWidgets('Share action with no content shows error snackbar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          reelsFeedProvider.overrideWith(
            _FakeShareUnavailableReelsFeedNotifier.new,
          ),
          isAuthenticatedProvider.overrideWithValue(false),
        ],
        child: const MaterialApp(
          home: ReelsFeedScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.tap(find.byIcon(Icons.send_outlined));
    await tester.pumpAndSettle();

    expect(
      find.text('Contenu indisponible pour le partage.'),
      findsOneWidget,
    );
  });

  testWidgets('Authenticated user tapping cart navigates to cart route', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const ReelsFeedScreen();
          },
        ),
        GoRoute(
          path: '/cart',
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(
              body: Center(child: Text('CartRoute')),
            );
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          reelsFeedProvider.overrideWith(_FakeSinglePostReelsFeedNotifier.new),
          isAuthenticatedProvider.overrideWithValue(true),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();

    expect(find.text('CartRoute'), findsOneWidget);
    router.dispose();
  });

  testWidgets(
    'Authenticated user tapping cart on linked product navigates to marketplace detail',
    (WidgetTester tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              return const ReelsFeedScreen();
            },
          ),
          GoRoute(
            path: '/marketplace/:productId',
            builder: (BuildContext context, GoRouterState state) {
              final productId = state.pathParameters['productId']!;
              return Scaffold(
                body: Center(child: Text('MarketplaceRoute:$productId')),
              );
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: <Override>[
            reelsFeedProvider.overrideWith(
              _FakeMarketplaceLinkedReelsFeedNotifier.new,
            ),
            isAuthenticatedProvider.overrideWithValue(true),
            marketplaceProductPreviewProvider.overrideWith(
              (ref, productUid) async => null,
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is Icon &&
              widget.icon == Icons.shopping_bag_outlined &&
              widget.size == 28,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('MarketplaceRoute:prod-42'), findsOneWidget);
      router.dispose();
    },
  );

  testWidgets('Owner long-press shows owner management action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          reelsFeedProvider.overrideWith(_FakeSinglePostReelsFeedNotifier.new),
          isAuthenticatedProvider.overrideWithValue(true),
          currentUserProvider.overrideWithValue(
            const UserModel(
              id: 'user-1',
              email: 'owner@test.com',
              username: 'alice',
              displayName: 'Alice Owner',
              createdAt: '2026-01-01T00:00:00Z',
              updatedAt: '2026-01-01T00:00:00Z',
            ),
          ),
        ],
        child: const MaterialApp(
          home: ReelsFeedScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.longPress(find.byType(ReelsFeedScreen));
    await tester.pumpAndSettle();

    expect(find.text('Actions rapides'), findsOneWidget);
    expect(find.text('Gerer ma publication'), findsOneWidget);
  });

  testWidgets('Non-owner long-press shows report action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          reelsFeedProvider.overrideWith(_FakeSinglePostReelsFeedNotifier.new),
          isAuthenticatedProvider.overrideWithValue(true),
          currentUserProvider.overrideWithValue(
            const UserModel(
              id: 'user-99',
              email: 'viewer@test.com',
              username: 'viewer',
              displayName: 'Viewer User',
              createdAt: '2026-01-01T00:00:00Z',
              updatedAt: '2026-01-01T00:00:00Z',
            ),
          ),
        ],
        child: const MaterialApp(
          home: ReelsFeedScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.longPress(find.byType(ReelsFeedScreen));
    await tester.pumpAndSettle();

    expect(find.text('Actions rapides'), findsOneWidget);
    expect(find.text('Signaler ce reel'), findsOneWidget);
    expect(find.text('Gerer ma publication'), findsNothing);
  });
}
