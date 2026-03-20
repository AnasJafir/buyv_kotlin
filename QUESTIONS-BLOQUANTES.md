# ❓ Questions Bloquantes — Migration BuyV KMP → Flutter

---

## ✅ Décisions Validées (19 Mars 2026)

- State management valide : **Riverpod**
- Stockage offline valide : **Hive**
- Scope valide : **toutes les features sont migrees** (CJ Import, Admin, Promoter, Camera, Sounds inclus)
- Config/cles valides : disponibles via **.env**
- Approche valide : **pragmatique, sans perfectionnisme bloquant**

---

## 🟢 Décisions Architecturales (Clôturées)

### Q1 : State Management — Riverpod vs BLoC ?
**Contexte :** Le code KMP utilise `MutableStateFlow` + MVVM. Les deux options Flutter principales :
- **Riverpod 2.x** : Plus proche du pattern actuel (provider-based, reactive), moins de boilerplate
- **BLoC** : Plus structuré (events/states), meilleur pour les équipes larges

> **Décision validée :** Riverpod (coherent avec le flow actuel).

### Q2 : Offline-First — Hive vs Isar vs Drift ?
**Contexte :** Le cart KMP est offline-first (`CartStorage`). Choix pour Flutter :
- **Hive** : Simple, rapide, NoSQL — adapté pour cart, préférences
- **Isar** : Plus moderne, requêtes complexes — adapté si besoin de search offline
- **Drift** : SQLite wrapper — adapté si les données sont relationnelles

> **Décision validée :** Hive pour le cart + shared_preferences pour les flags simples.

### Q3 : Le feed Reels doit-il supporter le mode "Following" côté serveur ou client ?
**Contexte :** `ReelsScreenViewModel.getReelsFromUsers()` filtre côté client (filtre les reels locaux par userId). Cela ne scale pas.
- **Option A :** Endpoint backend `GET /api/posts/feed?tab=following` (filtrage serveur)
- **Option B :** Garder le filtrage client (comme actuellement)

> **Impact :** Nombre de requêtes API, performance, UX

---

## 🟡 Points Non Clairs dans le Code KMP

### Q4 : CartRepository — Migration Status ?
**Code :** [ReelsScreenViewModel.kt](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/e-commerceAndroidApp/src/main/java/com/project/e_commerce/android/presentation/viewModel/reelsScreenViewModel/ReelsScreenViewModel.kt) ligne 53 :
```kotlin
private val cartRepository: CartRepository? = null, // ⚠️ MIGRATION: Made optional
```
- Le `CartRepository` dans le ViewModel Reels est marqué `optional` avec un commentaire "MIGRATION"
- **Question :** Le cart est-il fonctionnel actuellement ? Faut-il le reproduire à l'identique en Flutter ou le redessiner ?

### Q5 : PostEventBus — Global Event Propagation ?
**Code :** [ProfileViewModel.kt](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/e-commerceAndroidApp/src/main/java/com/project/e_commerce/android/presentation/viewModel/profileViewModel/ProfileViewModel.kt) ligne 329 :
```kotlin
com.project.e_commerce.android.utils.PostEventBus.emit(PostEvent.PostDeleted(postId))
```
- Le `PostEventBus` est un mécanisme d'événements global (Android-only)
- **Question :** Est-ce que tous les ViewModels s'y abonnent correctement ? Le QA Report mentionne des reels "ghost", ce qui suggère un problème de propagation.

### Q6 : AdminApi — Retrofit vs Ktor ?
**Constat :** L'admin panel Android utilise **Retrofit** ([AdminApi.kt](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/e-commerceAndroidApp/src/main/java/com/project/e_commerce/android/data/api/AdminApi.kt)) tandis que le reste de l'app utilise **Ktor** (shared module).
- Cela crée deux systèmes HTTP parallèles
- **Question :** Pourquoi cette dualité ? L'admin panel a-t-il des contraintes spécifiques ?
- **Flutter :** Tout sera unifié sous **dio**, pas de dualité.

### Q7 : Fonctionnalités TODO non implémentées
**Code :** [ReelsScreenViewModel.kt](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/e-commerceAndroidApp/src/main/java/com/project/e_commerce/android/presentation/viewModel/reelsScreenViewModel/ReelsScreenViewModel.kt) lignes 567-577 :
```kotlin
override fun onPauseVideo() { TODO("Not yet implemented") }
override fun onResumeVideo() { TODO("Not yet implemented") }
override fun onTwoClickToVideo() { TODO("Not yet implemented") }
```
- **Question :** Ces fonctionnalités doivent-elles être implémentées dans Flutter ou ignorées ?

---

## 🟠 Accès Manquants

### Q8 : Documentation API Backend
- [ ] **OpenAPI/Swagger spec** — Le backend FastAPI a-t-il un `/docs` accessible ?
- [ ] **Postman collection** — Existe-t-il une collection de tests API ?
- [x] L'URL de production Railway est-elle stable (`buyvkotlin-production.up.railway.app`) ?

### Q9 : Design System / Maquettes
- [ ] **Figma/Sketch** — Y a-t-il des maquettes UI officielles ?
- [ ] **Assets** — Les fichiers Lottie (heart animation), icônes catégories, sont-ils disponibles ?
- [ ] Le dossier `Photos/` dans le repo contient-il des screenshots de référence ?

### Q10 : Firebase Configuration
- [x] [google-services.json](file:///c:/Users/user/Desktop/Buyv/buyv_kotlin/e-commerceAndroidApp/google-services.json) doit être regénéré pour le nouveau package Flutter
- [x] `GoogleService-Info.plist` (iOS) — disponible
- [x] Clés SHA-1 / SHA-256 debug + release configurées
- [x] Firebase Messaging (push notifications) — configuration disponible via `.env`

### Q11 : Stripe Configuration
- [x] Clé publishable Stripe (test + live) disponible
- [x] Webhook endpoint configuré côté backend pour `flutter_stripe`

### Q12 : Cloudinary Configuration
- [x] Cloud name, API key, API secret — disponibles pour Flutter
- [x] Un preset d'upload est-il configuré (unsigned upload)

---

## 🔵 Clarifications Fonctionnelles

### Q13 : Scope de la migration — Features à garder ou supprimer ?
Le QA Report mentionne des features demandées par le client. Sont-elles toutes à migrer ?

| Feature | Status KMP | Migrer ? |
|---------|-----------|----------|
| CJ Dropshipping Import | ✅ Fonctionnel | ✅ Oui |
| Promoter Dashboard (commissions) | ✅ Fonctionnel | ✅ Oui |
| Admin Panel Mobile (14 écrans) | ✅ Fonctionnel | ✅ Oui |
| Caméra avec filtres GPU | 🟡 Partiel | ✅ Oui |
| Sound extraction/réutilisation | 🟡 Partiel | ✅ Oui |
| Tracking Analytics (affiliés) | ✅ Fonctionnel | ✅ Oui |

### Q14 : Support iOS — Contraintes spécifiques ?
- Le projet KMP a un dossier `e-commerceiosApp/` (SwiftUI, 28 écrans)
- **Question :** Le Flutter ciblant iOS+Android, faut-il tester sur des devices iOS dès le départ ?
- Configuration requise : macOS + Xcode pour build iOS

### Q15 : Performances — Benchmarks cibles ?
- [ ] 60fps scroll sur le feed Reels — quels devices cibles ?
- [ ] Temps de chargement initial acceptable ? (< 2s ? < 3s ?)
- [ ] Taille APK/IPA max acceptable ?

---

## Résumé des Actions Requises

| # | Question | Bloquant Pour |
|---|----------|--------------|
| Q3 | Following feed server vs client | Phase 2 |
| Q4 | CartRepository migration status | Phase 3 |
| Q8 | API docs / Swagger access | Phase 0 |
| Q9 | Design system / Figma | Phase 0 |
| Q14 | iOS test strategy (des le depart) | Toutes phases |
| Q15 | Benchmarks performance cibles | Phases 2 a 6 |

---

## Note d'Execution

Les decisions validees ci-dessus sont considerees comme baseline de travail.

### Politique de Livraison (Version Non Finale)

- Toutes les fonctionnalites deja definies dans le scope doivent etre implementees en integralite.
- L'objectif prioritaire est la couverture fonctionnelle complete, pas la perfection technique immediate.
- Tout defi technique non bloquant la livraison fonctionnelle est note, trace, puis reporte en fin d'implementation.
- Les reports doivent etre explicites (probleme, impact, workaround, phase de reprise).

### Registre des Defis Techniques Reportes (a alimenter)

| ID | Defi technique | Impact actuel | Workaround applique | Reprise prevue |
|----|----------------|---------------|---------------------|----------------|
| DT-001 | Q3 - Following feed serveur vs client | Performance/scalabilite potentielle | Fallback client temporaire possible | Fin Phase 2 |
| DT-002 | Q4 - CartRepository KMP optionnel | Risque d'ecart de comportement cart | Parity-first Hive + tests parcours achat | Fin Phase 3 |
| DT-003 | Q14 - Cadence tests iOS | Risque de detection tardive sur iOS | Smoke tests iOS hebdomadaires | Fin Phase 6 |
| DT-004 | Q15 - Benchmarks perf cibles | Validation perf moins objective | Seuils provisoires (fps/startup/taille) | Fin Phase 6 |
