# Coding Standards

## General Principles

1. **Readability over cleverness** — Write code for humans first, compilers second.
2. **Consistency** — Follow established patterns; don't invent new ones unless justified.
3. **Immutability** — Prefer `final` variables and immutable state (Freezed).
4. **Single Responsibility** — Each class/function does one thing well.
5. **Dependency Injection** — Use Riverpod for all dependency provision.

## Dart Style

### Prefer `const` constructors

```dart
// ✅ Good
const SizedBox(height: 16);

// ❌ Bad
SizedBox(height: 16);
```

### Use cascade operator

```dart
// ✅ Good
final client = Dio()
  ..options.baseUrl = baseUrl
  ..interceptors.addAll([authInterceptor, logger]);

// ❌ Bad
final client = Dio();
client.options.baseUrl = baseUrl;
client.interceptors.addAll([authInterceptor, logger]);
```

### Use collection if/for

```dart
// ✅ Good
final items = [
  'home',
  if (isAdmin) 'admin',
  for (final item in list) item.name,
];

// ❌ Bad
final items = ['home'];
if (isAdmin) items.add('admin');
```

### Use tear-offs

```dart
// ✅ Good
onPressed: onSubmit,

// ❌ Bad
onPressed: () => onSubmit(),
```

## Widget Conventions

1. **Extract private widget classes** when a widget subtree is reused within the same file.
2. **Use `SizedBox` instead of `Container`** when only sizing is needed.
3. **Use `gap` package** for spacing: `const Gap(16)` instead of `SizedBox(height: 16)`.
4. **Sort constructor parameters**: required first, then optional.
5. **Always use `const`** for static widget trees.

```dart
// ✅ Good
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Gap(32),
              _LoginHeader(),
              Gap(24),
              _LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
```

## State Management Rules

1. **Providers are written manually** (no `@riverpod`/riverpod_generator).
2. **Domain models** use `@freezed` + `json_serializable`.
3. **Async operations** use `AsyncValue` from Riverpod.
4. **Never** use `ref.read` inside build methods — use `ref.watch`.
5. **Never** use `ref.watch` inside callbacks — use `ref.read`.

## Error Handling

1. **Always catch specific exceptions** — use `on` clauses, not bare `catch`.
2. **Wrap in try-catch at repository level**, not in UI.
3. **Return `Result` type or use `AsyncValue`** for error propagation.
4. **Log errors** with the app logger, never `print()`.

## Testing Requirements

1. Write unit tests for all business logic (repositories, providers).
2. Write widget tests for reusable widgets.
3. Mock dependencies using Riverpod overrides.
4. Target 80%+ code coverage on domain layer.

## Performance

1. **`const` constructors** everywhere possible.
2. **`ListView.builder`** for long lists.
3. **Avoid rebuilds** — use `select` on Riverpod providers.
4. **Lazy initialization** with `late final` for expensive objects.
5. **Dispose** controllers and subscriptions in `dispose()`.
