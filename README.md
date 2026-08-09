# Cause Explorer

A small Flutter screen that lists causes from a public API, with search, category filtering,
favorites and a detail view. All of it is driven by shared state, not local widget state.

## Run

```bash
flutter pub get
flutter run
```

Runs on Android, iOS, web and desktop. Tests: `flutter test`.

## State management: Riverpod

- `AsyncValue` from `AsyncNotifier` gives loading, error and data states without hand-rolling a
  union type, so the list screen covers all three in one `when`.
- Search, category and favorites are separate providers that `filteredCausesProvider` composes.
  Filtering lives there, not in widgets.
- `isFavoriteProvider` is a `Provider.family<bool, int>`, so a card rebuilds only when its own
  favorite flag changes rather than on every favorite anywhere.
- The detail screen reads the same `favoritesProvider`, so toggling on either screen is reflected
  on the other.
- `ProviderContainer` with an overridden repository makes the filter and favorite logic testable
  without a network call.

## Structure

```
lib/
  core/            network client, error mapping, theme, helpers
  features/causes/
    model/         Cause, CauseCategory
    data/          Dio API client and repository
    provider/      Riverpod providers and notifiers
    view/          list and detail screens
    widget/        cards, chips, search field, state views
```

Feature-first, so everything about causes lives in one place, split into model / data / provider /
view so the UI never touches Dio and the data layer never touches widgets. `core/` holds only what a
second feature would reuse unchanged.

## Category mapping

`/posts` has no category, so it is derived from `userId`:

```dart
CauseCategory.values[(userId - 1) % 5]
```

| userId | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| category | Health | Education | Emergency | Environment | Empowerment | Health | Education | Emergency | Environment | Empowerment |

Images use `https://picsum.photos/seed/{id}/400/300`, so each cause keeps the same image.

## With more time

- Debounce the search input instead of filtering on every keystroke.
- `cached_network_image` for disk caching and smoother placeholders.
- Persist favorites with `shared_preferences` so they survive a restart.
- Skeleton placeholders instead of a single spinner.
- Golden tests for the card layouts at both breakpoints.
