# Contributing to CypherKeep

First off, thank you for considering contributing to CypherKeep! It's people like you that make CypherKeep such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by our commitment to providing a welcoming and inclusive environment. Please be respectful and constructive in all interactions.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the issue list as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

* **Use a clear and descriptive title** for the issue
* **Describe the exact steps to reproduce the problem**
* **Provide specific examples** to demonstrate the steps
* **Describe the behavior you observed and what you expected to see**
* **Include screenshots** if relevant
* **Include your environment details** (Flutter version, OS, device)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

* **Use a clear and descriptive title**
* **Provide a detailed description of the suggested enhancement**
* **Explain why this enhancement would be useful**
* **List some examples of how it would be used**

### Pull Requests

* Fill in the required template
* Do not include issue numbers in the PR title
* Follow the Dart/Flutter style guide
* Include thoughtful commit messages
* Update documentation as needed
* Add tests if applicable

## Development Setup

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/YOUR-USERNAME/cipherkeep.git
   cd cipherkeep
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make your changes**
   - Write clean, documented code
   - Follow existing code style
   - Add tests for new features

5. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   dart format lib/
   ```

6. **Commit your changes**
   ```bash
   git add .
   git commit -m "✨ Add your feature description"
   ```

7. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Open a Pull Request**

## Style Guide

### Dart Code Style

* Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style)
* Use `dart format` before committing
* Use meaningful variable and function names
* Add comments for complex logic
* Keep functions small and focused

### Commit Messages

We use conventional commits format:

* `✨ feat:` for new features
* `🐛 fix:` for bug fixes
* `📝 docs:` for documentation changes
* `🎨 style:` for formatting changes
* `♻️ refactor:` for code refactoring
* `✅ test:` for adding tests
* `⚡ perf:` for performance improvements
* `🔧 chore:` for maintenance tasks

### File Organization

```
lib/
├── core/          # Core utilities, constants, themes
├── data/          # Models and services
├── logic/         # State management (Riverpod)
└── presentation/  # UI (screens and widgets)
```

## Security

### Reporting Security Issues

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please send an email to [your-email@example.com] with:
* Description of the vulnerability
* Steps to reproduce
* Potential impact
* Suggested fix (if any)

## Questions?

Feel free to open an issue with your question or reach out to the maintainers.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to CypherKeep! 🔐
