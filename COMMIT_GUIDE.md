# Commit Guide for Dompet

This guide outlines the commit conventions for the Dompet project, following [Conventional Commits](https://www.conventionalcommits.org/) specification to ensure consistency and clarity in our commit history.

## Commit Format

Each commit message should follow this format:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Type

Must be one of the following:

- `feat`: A new feature or enhancement
- `fix`: A bug fix
- `docs`: Documentation changes only
- `style`: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `build`: Changes that affect the build system or external dependencies
- `ci`: Changes to CI configuration files and scripts
- `chore`: Other changes that don't modify source code or tests
- `revert`: Reverts a previous commit

## Scope (Optional)

The scope provides additional contextual information and should be a short identifier related to the affected module or feature. Examples:

- `auth`: Authentication related changes
- `pocket`: Pocket feature changes
- `account`: Account related functionality
- `ui`: User interface changes
- `api`: API related changes

## Examples

### Valid Commit Messages

```
feat(pocket): add spending pocket creation functionality

- Implement form for creating new spending pockets
- Add validation for pocket name and initial amount
- Create API integration for pocket creation
```

```
fix(account): resolve null pointer exception in account balance calculation

- Check for null values before performing calculations
- Add proper error handling for edge cases
- Update tests to cover null scenarios
```

```
docs: update README with installation instructions

- Add prerequisites section
- Include step-by-step setup guide
- Update screenshots and code examples
```

```
refactor(ui): migrate spending page to use Riverpod state management

- Replace Provider with Riverpod for dependency injection
- Update widget structure to work with Riverpod
- Update related tests to use Riverpod testing utilities
```

```
perf(api): optimize API request batching for transaction loading

- Implement request batching to reduce network calls
- Add caching layer for frequently accessed data
- Improve response time by ~40%
```

### Invalid Commit Messages

```
// Don't capitalize the first letter of the description
Feat: Add new feature
```

```
// Don't add periods to the end of the description
feat: add new feature.
```

```
// Don't use imperative mood
feat: added new feature
```

```
// Don't include too much detail in the header
feat: Implement complex feature with multiple sub-features that require detailed explanation
```

## Breaking Changes

Include breaking changes in the commit body or footer:

```
feat(api): change user authentication API

- Update to OAuth 2.0 flow
- Remove legacy token authentication

BREAKING CHANGE: This changes the authentication API and
requires all client implementations to update their authentication
logic.
```

## Best Practices

1. **Use imperative mood**: Write commits as if giving commands or instructions
   - ✅ "Add", "Fix", "Update", "Remove"
   - ❌ "Added", "Fixed", "Updated", "Removed"

2. **Be concise but descriptive**: The first line should be a summary of what the commit does

3. **Capitalize the type**: Start the type with a capital letter only when needed

4. **Reference issues**: When appropriate, reference related issues in the footer
   ```
   Closes #123
   Related to #456
   ```

5. **Keep commits focused**: Each commit should represent a single logical change

## Verification

To ensure your commits follow these conventions, consider using a git hook or linter that validates commit messages against this specification.

## Additional Resources

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Angular Commit Message Conventions](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines)
- [A Note About Git Commit Messages](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)