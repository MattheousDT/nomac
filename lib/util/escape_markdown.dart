String escapeMarkdown(String text) => text.replaceAllMapped(
      RegExp(r'(\*|_|`|~|\\)', caseSensitive: false),
      (match) => '\\${match.group(0)}',
    );
