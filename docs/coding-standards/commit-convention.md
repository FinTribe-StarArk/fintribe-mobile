# Commit Convention

## Format

```
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

## Types

| Type       | Description                                    |
|------------|------------------------------------------------|
| `feat`     | New feature                                    |
| `fix`      | Bug fix                                        |
| `refactor` | Code refactoring (no feature, no bug fix)      |
| `style`    | Formatting, lint fixes (no code change)        |
| `docs`     | Documentation changes                          |
| `test`     | Adding/updating tests                          |
| `chore`    | Build process, dependencies, CI changes        |
| `perf`     | Performance improvement                        |
| `ci`       | CI/CD configuration changes                    |

## Scopes

| Scope       | Area                          |
|-------------|-------------------------------|
| `auth`      | Authentication feature        |
| `core`      | Core infrastructure           |
| `network`   | Networking layer              |
| `theme`     | Theming, colors, styles       |
| `router`    | Navigation, routing           |
| `storage`   | Local storage, Hive           |
| `widgets`   | Reusable widgets              |

## Rules

1. Subject line ≤ 72 characters.
2. Use imperative mood: "add" not "added" or "adds".
3. No period at the end of subject line.
4. Separate subject from body with a blank line.
5. Reference issues with `#` in footer.

## Examples

```
feat(auth): add login with email and password

Implement email/password login flow with Dio API client.
Includes form validation and error handling.

Closes #42
```

```
fix(network): resolve token refresh race condition

Use a mutex lock to prevent concurrent refresh calls.
```

```
refactor(core): migrate theme to use ColorScheme

Replace manual color definitions with Material 3 ColorScheme.
```
