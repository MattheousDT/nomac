export const escapeMarkdown = (str: string) => str.replace(/(\*|_|`|~|\\)/gi, "\\$1");
