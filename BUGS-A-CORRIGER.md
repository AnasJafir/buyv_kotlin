# 🐛 Bugs Identifiés dans le Code KMP — Ne PAS Reproduire dans Flutter

**Source :** QA Report BuyV (1er Mars 2026) + Analyse du code source
**Total :** 32 bugs (5 CRITICAL, 13 HIGH, 11 MEDIUM, 3 LOW)

---

## 🔴 BUGS CRITICAL (5)

### 🐛 Bug #1 : Back Press ferme l'app au lieu du BottomSheet Buy
**ID QA :** VIDEO-004 | **Photo :** 20
**Symptôme :** Appuyer sur le bouton retour dans le BottomSheet Buy ferme l'application entièrement
**Cause racine KMP :**
- L'activité hôte ne surcharge pas `onBackPressed()` pour interception
- Le `BottomSheetBehavior` n'est pas connecté au `OnBackPressedDispatcher`
- Pas de callback Jetpack pour gérer la stack de BottomSheets

**Solution Flutter :**
- [x] Utiliser `WillPopScope` / `PopScope` widget pour intercepter back
- [x] `showModalBottomSheet()` gère nativement le back press (dismiss)
- [x] Pattern : `Navigator.of(context).maybePop()` au lieu de `SystemNavigator.pop()`
- [x] Tests d'intégration : vérifier que back press ferme le sheet sans quitter l'app

```dart
// Flutter gère ça nativement avec showModalBottomSheet
showModalBottomSheet(
  context: context,
  isDismissible: true, // back press = dismiss
  enableDrag: true,
  builder: (context) => BuyBottomSheet(),
);
```

---

### 🐛 Bug #2 : Crash navigation vers profil créateur (NullPointerException)
**ID QA :** SET-002 | **Photo :** 7
**Symptôme :** Crash bloquant lors de la navigation vidéo → profil créateur
**Cause racine KMP :**
- [ReelsScreenViewModel.kt](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/e-commerceAndroidApp/src/main/java/com/project/e_commerce/android/presentation/viewModel/reelsScreenViewModel/ReelsScreenViewModel.kt) ligne ~309 : `reel.userId` peut être `"unknown_user"` ou vide
- `UserProfileScreen` tente un fetch avec un userId invalide → NPE
- Pas de null-check avant `getUserProfileUseCase(userId)`
- Fallback `"User_${reel.userId.take(6)}"` ne protège pas la navigation

**Solution Flutter :**
- [ ] Null safety strict Dart : `String? userId` avec early return
- [ ] Guard dans la navigation : `if (userId == null || userId == 'unknown_user') return;`
- [ ] Error boundary widget autour de `UserProfileScreen`
- [ ] Test unitaire : naviguer vers profil avec userId null/vide/invalid

---

### 🐛 Bug #3 : Erreur serialization SoundDto affichée à l'utilisateur
**ID QA :** SOUND-001 | **Photo :** 26
**Symptôme :** Message technique `"Fields [id, uid, title, artist, audioUrl, createdAt] are required..."` visible
**Cause racine KMP :**
- Le backend retourne un objet Sound partiel (post-extraction "original sound")
- [SoundDto](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/shared/src/commonMain/kotlin/com/project/e_commerce/data/remote/dto/BackendDtos.kt#508-522) avait des champs requis sans valeurs par défaut (corrigé depuis dans le code)
- L'erreur `MissingFieldException` n'est pas catchée au niveau UI
- Le stacktrace est affiché directement dans un composant texte

**Solution Flutter :**
- [ ] Modèle [Sound](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/shared/src/commonMain/kotlin/com/project/e_commerce/data/remote/dto/BackendDtos.kt#508-522) avec tous champs optionnels + valeurs par défaut via `freezed`
- [ ] `try-catch` autour du JSON parsing avec fallback gracieux
- [ ] Afficher message user-friendly : "Son non disponible"
- [ ] Log l'erreur technique dans un service de crash reporting (Crashlytics)

```dart
@freezed
class Sound with _$Sound {
  factory Sound({
    @Default(0) int id,
    @Default('') String uid,
    @Default('Original Sound') String title,
    @Default('Unknown') String artist,
    @Default('') String audioUrl,
    @Default('') String createdAt,
  }) = _Sound;
  
  factory Sound.fromJson(Map<String, dynamic> json) => _$SoundFromJson(json);
}
```

---

### 🐛 Bug #4 : HTML brut visible dans la caption Promote Product
**ID QA :** UPLOAD-002 | **Photo :** 25
**Symptôme :** Balises `<p>`, `<b>`, `<br/>`, `<img>` affichées en texte dans le champ caption
**Cause racine KMP :**
- [HtmlSanitizer.kt](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/shared/src/commonMain/kotlin/com/project/e_commerce/data/util/HtmlSanitizer.kt) existe dans le shared module mais n'est PAS appliqué au champ caption
- La description produit CJ contient du HTML brut copié tel quel
- Pas de conversion HTML → texte plain avant pré-remplissage

**Solution Flutter :**
- [ ] Créer utility `HtmlSanitizer.stripTags(html)` avec [html](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/QA_CHECKLIST_BUYV.html) package
- [ ] Appliquer systématiquement avant tout affichage de texte produit
- [ ] Widget `flutter_html` pour les descriptions formatées (pas dans les inputs)
- [ ] Regex fallback : `htmlString.replaceAll(RegExp(r'<[^>]*>'), '')`

---

### 🐛 Bug #5 : SHA-1 Google Sign-In non configuré (Developer Error)
**ID QA :** AUTH-001 | **Photo :** 7
**Symptôme :** Toast "Developer Error: Check SHA-1 fingerprint" sur Google Sign-In
**Cause racine KMP :**
- [google-services.json](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/e-commerceAndroidApp/google-services.json) ne contient pas le SHA-1 du keystore release
- Build config signe debug avec keystore release (ligne 78 [build.gradle.kts](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/build.gradle.kts))
- Firebase Console manque les empreintes SHA-256

**Solution Flutter :**
- [ ] Configurer Firebase pour Flutter avec `flutterfire configure`
- [ ] Ajouter SHA-1 + SHA-256 (debug ET release) dans Firebase Console
- [ ] [google-services.json](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/e-commerceAndroidApp/google-services.json) (Android) + `GoogleService-Info.plist` (iOS) corrects
- [ ] Test login Google sur APK release + TestFlight

---

## 🟠 BUGS HIGH (13)

### 🐛 Bug #6 : Bouton '+' (CTA Upload) non intuitif / superposé par Buy
**ID QA :** UPLOAD-001 | **Photo :** 1
**Symptôme :** Le flux d'upload de contenu n'est pas trouvable par les utilisateurs
**Cause racine :** Pas de FAB central visible, le CTA est caché dans le menu profil
**Solution Flutter :**
- [ ] `FloatingActionButton` central dans `BottomNavigationBar` ou onglet dédié "+"
- [ ] Navigation directe vers `CreateContentScreen`
- [ ] Conditional visibility : ne PAS afficher si bouton Buy est actif sur le même écran

### 🐛 Bug #7 : Icône Pause persiste après reprise vidéo
**ID QA :** VIDEO-001 | **Photos :** 4, 12
**Symptôme :** L'icône Pause (II) reste visible au centre de la vidéo après reprise
**Cause racine :** `View.GONE` jamais appelé sur le [onResume](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/e-commerceAndroidApp/src/main/java/com/project/e_commerce/android/presentation/viewModel/reelsScreenViewModel/ReelsScreenViewModel.kt#571-574)/touch listener
**Solution Flutter :**
- [ ] `AnimatedOpacity` avec fade-out après 1.5s d'inactivité
- [ ] State machine Play/Pause/Buffering claire avec `ValueNotifier`
- [ ] Gesture detection : tap = toggle play/pause + reset timer fade-out

### 🐛 Bug #8 : Follow button disparaît vs devient grisé
**ID QA :** SET-003 | **Photo :** 4
**Symptôme :** Après follow, le bouton disparaît (GONE) au lieu de rester visible en état "Following"
**Solution Flutter :**
- [ ] Bouton toggle : `Follow ➟ Following` avec style différent (outlined vs filled)
- [ ] Jamais `Visibility.gone`, toujours toggle d'état

### 🐛 Bug #9 : Merge Save + Cart en un seul bouton
**ID QA :** SET-004 | **Photo :** 4
**Symptôme :** L'icône sauvegarde coexiste avec l'icône panier, confusion utilisateur
**Cause racine :** `SaveAndCartUseCase` existe dans Koin mais les UI n'utilisent pas
**Solution Flutter :**
- [ ] Action unique "Add to Cart" : `saveVideo() + addProductToCart()` en une opération
- [ ] Supprimer icône bookmark dédiée des reels (fusionner dans Cart)

### 🐛 Bug #10 : Sélecteur langue non fonctionnel
**ID QA :** SET-001 | **Photo :** 5
**Symptôme :** Tap sur "Language" dans Settings n'a aucun effet
**Solution Flutter :**
- [ ] `flutter_localizations` + `intl` avec `AppLocalizations`
- [ ] BottomSheet sélection langue → `Locale` switch → rebuild MaterialApp

### 🐛 Bug #11 : Mode Guest (skip onboarding) non implémenté
**ID QA :** AUTH-003/004 | **Photos :** 19, 21
**Symptôme :** L'onboarding + login est obligatoire avant de voir le contenu
**Cause racine :** Navigation `SplashScreen → LoginScreen → ReelsScreen` est linéaire
**Solution Flutter :**
- [ ] Route initiale = [ReelsScreen](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/e-commerceAndroidApp/src/main/java/com/project/e_commerce/android/presentation/viewModel/reelsScreenViewModel/ReelsScreenViewModel.kt#43-850) (pas login)
- [ ] `AuthGuard` middleware : intercepte actions sensibles (like, comment, cart)
- [ ] `showLoginBottomSheet()` au lieu de naviguer vers login screen
- [ ] Post-login : reprendre l'action interrompue

### 🐛 Bug #12 : Reels "Ghost" dans la grille Profile
**Symptôme :** Reels supprimés apparaissent aléatoirement dans la grille profil
**Cause racine (code) :**
- [ProfileViewModel.kt](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/e-commerceAndroidApp/src/main/java/com/project/e_commerce/android/presentation/viewModel/profileViewModel/ProfileViewModel.kt) : `_userReels` est chargé via `getUserReelsUseCase(userId)` sans forcer un refresh depuis le backend
- `PostEventBus.emit(PostDeleted(postId))` émet l'événement mais le [ProfileViewModel](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/e-commerceAndroidApp/src/main/java/com/project/e_commerce/android/presentation/viewModel/profileViewModel/ProfileViewModel.kt#17-347) ne s'y abonne pas activement
- `_userReels.value = _userReels.value.filter { it.id != postId }` (ligne 326) ne filtre que localement
- Au prochain [loadUserProfile()](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/e-commerceAndroidApp/src/main/java/com/project/e_commerce/android/presentation/viewModel/profileViewModel/ProfileViewModel.kt#56-241) le backend peut retourner des posts "soft-deleted" si `is_deleted` n'est pas filtré côté serveur

**Solution Flutter :**
- [ ] Cache invalidation : `Hive.box('userPosts').delete(postId)` + `ref.invalidate(userPostsProvider)`
- [ ] Backend fix : vérifier que `GET /api/posts/user/{id}` filtre `is_deleted = true`
- [ ] Optimistic UI : suppression locale immédiate + error rollback
- [ ] `StreamController` pour PostEventBus Flutter → tous les listeners se mettent à jour
- [ ] Test : supprimer un reel, naviguer away, revenir au profil → reel ne doit plus apparaître

### 🐛 Bug #13 : Caractères OBJ (U+FFFC) corrompus
**ID QA :** UI-003 | **Photos :** 20, 22
**Symptôme :** Rectangles "[OBJ]" au lieu des emojis
**Solution Flutter :**
- [ ] Flutter gère nativement les emojis Unicode (pas besoin de EmojiCompat)
- [ ] Filtrer U+FFFC côté input si des descriptions CJ contiennent des placeholders

### 🐛 Bug #14 : URL image brute dans ProductDetail
**ID QA :** PROD-002 | **Photo :** 23
**Symptôme :** `<img src="https://cf.cjdropshipping.com/..."` visible dans description
**Solution Flutter :**
- [ ] `flutter_html` package pour render HTML descriptions
- [ ] Extraire `<img>` tags et les afficher dans un `PageView` carousel séparé
- [ ] Texte nettoyé affiché dans `Text()` widget

### 🐛 Bug #15 : Auth guard manquant sur upload
**ID QA :** UPLOAD-004 | **Photo :** 8
**Symptôme :** "User not authenticated" affiché à l'utilisateur
**Solution Flutter :**
- [ ] `AuthGuard` intercepteur : si token absent → `showLoginBottomSheet()`
- [ ] Ne JAMAIS laisser accéder à une screen d'upload sans token

### 🐛 Bug #16 : Owner mode masque tous boutons sauf Edit/Delete
**ID QA :** VIDEO-003 | **Photo :** 12
**Cause racine :** Mode owner ne distingue pas correctement owns vs not-owns
**Solution Flutter :**
- [ ] `if (reel.userId == currentUser.id)` → afficher overlay Edit/Delete/Visibility
- [ ] Sinon → afficher Like, Comment, Share, Cart normalement

### 🐛 Bug #17 : Catégories frontend non connectées
**ID QA :** CAT-001 | **Photos :** 28, 29
**Solution Flutter :**
- [ ] `CategoryChip` widgets horizontaux
- [ ] `GET /api/categories` (actives uniquement)
- [ ] Filter produits par `category_slug` sélectionné

### 🐛 Bug #18 : Icônes catégories = placeholder panier
**ID QA :** CAT-005 | **Photo :** 30
**Cause racine :** Champ `icon_url` vide dans la base de données, fallback = `ic_cart`
**Solution Flutter :**
- [ ] Fallback par slug : `Map<String, IconData>` → electronics, fashion, etc.
- [ ] Admin panel : uploader de vraies icônes catégorie

---

## 🟡 BUGS MEDIUM (11)

| ID | Bug | Solution Flutter |
|----|-----|-----------------|
| UI-001 | Bouton Buy bordures inconfortables | `ElevatedButton` avec `elevation: 0`, `shape: StadiumBorder()` |
| VIDEO-005 | Icônes sociales Filled au lieu d'Outlined | Utiliser `Icons.favorite_border` (outlined par défaut) |
| VIDEO-006 | Animation cœur double-tap basse qualité | `lottie` package avec fichier `lottie_heart_like.json` |
| PROD-001 | Carte produit trop grande | `ConstrainedBox(maxWidth: 160)` + collapse/expand |
| PROD-005 | Bannière promo hardcodée | `GET /api/home_banners` + `PageView` dynamique |
| COM-001 | Onglet Ratings sur commentaires | `TabBarView` avec tabs Comments / Rates |
| UI-004 | Vignettes profil carrées au lieu de 9:16 | `AspectRatio(aspectRatio: 9/16)` dans `GridView` |
| PROD-003 | Placeholder image = panier | `CachedNetworkImage` avec `shimmer` placeholder |
| CAT-003 | Filtres CJ non connectés | Dropdowns pays/catégorie sur CJ Import screen |
| CAT-004 | Empty state CJ | Charger trending CJ products sur `onInit` |
| VIDEO-002 | Icône Play visible pendant lecture | `AnimatedOpacity` → caché quand `isPlaying = true` |

---

## 🟢 BUGS LOW (3)

| ID | Bug | Solution Flutter |
|----|-----|-----------------|
| UI-002 | Spinners multiples couleurs incohérentes | Un seul `CircularProgressIndicator(color: primaryOrange)` centralisé |
| UI-005 | Menu contextuel long press | `showModalBottomSheet` avec Download/Not Interested/Report |
| PROD-004 | Product info overlay trop verbeux | `maxLines: 2, overflow: TextOverflow.ellipsis` |

---

## Résumé Actions Flutter

| Priorité | Count | Première action |
|----------|-------|----------------|
| 🔴 CRITICAL | 5 | Implémenter `PopScope`, null-safety navigation, `freezed` Sound, `HtmlSanitizer`, Firebase SHA-1 |
| 🟠 HIGH | 13 | Guest mode, FAB upload, PostEventBus sync, Auth guard |
| 🟡 MEDIUM | 11 | Outlined icons, Lottie animations, aspect ratios |
| 🟢 LOW | 3 | Unified spinner, context menu |
