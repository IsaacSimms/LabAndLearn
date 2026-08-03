# Overview

Nearly all Markdown applications support the basic syntax outlined in the original Markdown design document. There are minor variations and discrepancies between Markdown processors — those are noted inline wherever possible.

# Headings

To create a heading, add number signs (`#`) in front of a word or phrase. The number of number signs you use should correspond to the heading level. For example, to create a heading level three (`<h3>`), use three number signs (e.g., `### My Header`).

| Markdown | HTML | Rendered Output |
| --- | --- | --- |
| `# Heading level 1` | `<h1>Heading level 1</h1>` | Heading level 1 |
| `## Heading level 2` | `<h2>Heading level 2</h2>` | Heading level 2 |
| `### Heading level 3` | `<h3>Heading level 3</h3>` | Heading level 3 |
| `#### Heading level 4` | `<h4>Heading level 4</h4>` | Heading level 4 |
| `##### Heading level 5` | `<h5>Heading level 5</h5>` | Heading level 5 |
| `###### Heading level 6` | `<h6>Heading level 6</h6>` | Heading level 6 |

## Alternate Syntax

Alternatively, on the line below the text, add any number of `==` characters for heading level 1 or `--` characters for heading level 2.

| Markdown | HTML | Rendered Output |
| --- | --- | --- |
| `Heading level 1`<br>`===============` | `<h1>Heading level 1</h1>` | Heading level 1 |
| `Heading level 2`<br>`---------------` | `<h2>Heading level 2</h2>` | Heading level 2 |

## Heading Best Practices

Markdown applications don’t agree on how to handle a missing space between the number signs (`#`) and the heading name. For compatibility, always put a space between the number signs and the heading name.

| ✅ Do this | Don't do this |
| --- | --- |
| `# Here's a Heading` | `#Here's a Heading` |

You should also put blank lines before and after a heading for compatibility.

| ✅ Do this | Don't do this |
| --- | --- |
| Try to put a blank line before...<br><br>`# Heading`<br><br>...and after a heading. | Without blank lines, this might not look right.<br>`# Heading`<br>Don't do this! |

# Paragraphs

To create paragraphs, use a blank line to separate one or more lines of text.

| Markdown | HTML | Rendered Output |
| --- | --- | --- |
| I really like using Markdown.<br><br>I think I'll use it to format all of my documents from now on. | `<p>I really like using Markdown.</p>`<br><br>`<p>I think I'll use it to format all of my documents from now on.</p>` | I really like using Markdown.<br><br>I think I'll use it to format all of my documents from now on. |

## Paragraph Best Practices

Unless the paragraph is in a list, don’t indent paragraphs with spaces or tabs.

**Note:** If you need to indent paragraphs in the output, see the section on how to indent (tab).

| ✅ Do this | Don't do this |
| --- | --- |
| Don't put tabs or spaces in front of your paragraphs.<br><br>Keep lines left-aligned like this. | This can result in unexpected formatting problems.<br><br>Don't add tabs or spaces in front of paragraphs. |

# Line Breaks

To create a line break or new line (`<br>`), end a line with two or more spaces, and then type return.

| Markdown | HTML | Rendered Output |
| --- | --- | --- |
| This is the first line.<br>And this is the second line. | `<p>This is the first line.<br>`<br>`And this is the second line.</p>` | This is the first line.<br>And this is the second line. |

## Line Break Best Practices

You can use two or more spaces (commonly referred to as “trailing whitespace”) for line breaks in nearly every Markdown application, but it’s controversial. It’s hard to see trailing whitespace in an editor, and many people accidentally or intentionally put two spaces after every sentence. For this reason, you may want to use something other than trailing whitespace for line breaks. If your Markdown application supports HTML, you can use the `<br>` HTML tag.

For compatibility, use trailing white space or the `<br>` HTML tag at the end of the line.

There are two other options I don’t recommend using. CommonMark and a few other lightweight markup languages let you type a backslash (`\`) at the end of the line, but not all Markdown applications support this, so it isn’t a great option from a compatibility perspective. And at least a couple lightweight markup languages don’t require anything at the end of the line — just type return and they’ll create a line break.

| ✅ Do this | Don't do this |
| --- | --- |
| First line with two spaces after.<br>And the next line.<br><br>First line with the HTML tag after.`<br>`<br>And the next line. | First line with a backslash after.`\`<br>And the next line.<br><br>First line with nothing after.<br>And the next line. |

# Emphasis

You can add emphasis by making text bold or italic.

## Bold

To bold text, add two asterisks or underscores before and after a word or phrase. To bold the middle of a word for emphasis, add two asterisks without spaces around the letters.

| Markdown | HTML | Rendered Output |
| --- | --- | --- |
| `I just love **bold text**.` | `I just love <strong>bold text</strong>.` | I just love **bold text**. |
| `I just love __bold text__.` | `I just love <strong>bold text</strong>.` | I just love **bold text**. |
| `Love**is**bold` | `Love<strong>is</strong>bold` | Love**is**bold |

### Bold Best Practices

Markdown applications don’t agree on how to handle underscores in the middle of a word. For compatibility, use asterisks to bold the middle of a word for emphasis.

| ✅ Do this | Don't do this |
| --- | --- |
| `Love**is**bold` | `Love__is__bold` |

## Italic

To italicize text, add one asterisk or underscore before and after a word or phrase. To italicize the middle of a word for emphasis, add one asterisk without spaces around the letters.

| Markdown | HTML | Rendered Output |
| --- | --- | --- |
| `Italicized text is the *cat's meow*.` | `Italicized text is the <em>cat's meow</em>.` | Italicized text is the *cat's meow*. |
| `Italicized text is the _cat's meow_.` | `Italicized text is the <em>cat's meow</em>.` | Italicized text is the *cat's meow*. |
| `A*cat*meow` | `A<em>cat</em>meow` | A*cat*meow |

### Italic Best Practices

Markdown applications don’t agree on how to handle underscores in the middle of a word. For compatibility, use asterisks to italicize the middle of a word for emphasis.

| ✅ Do this | Don't do this |
| --- | --- |
| `A*cat*meow` | `A_cat_meow` |

## Bold and Italic

To emphasize text with bold and italics at the same time, add three asterisks or underscores before and after a word or phrase. To bold and italicize the middle of a word for emphasis, add three asterisks without spaces around the letters.

| Markdown | HTML | Rendered Output |
| --- | --- | --- |
| `This text is ***really important***.` | `This text is <em><strong>really important</strong></em>.` | This text is ***really important***. |
| `This text is ___really important___.` | `This text is <em><strong>really important</strong></em>.` | This text is ***really important***. |
| `This text is __*really important*__.` | `This text is <em><strong>really important</strong></em>.` | This text is ***really important***. |
| `This text is **_really important_**.` | `This text is <em><strong>really important</strong></em>.` | This text is ***really important***. |
| `This is really***very***important text.` | `This is really<em><strong>very</strong></em>important text.` | This is really***very***important text. |

**Note:** The order of the `em` and `strong` tags might be reversed depending on the Markdown processor you're using.

### Bold and Italic Best Practices

Markdown applications don’t agree on how to handle underscores in the middle of a word. For compatibility, use asterisks to bold and italicize the middle of a word for emphasis.

| ✅ Do this | Don't do this |
| --- | --- |
| `This is really***very***important text.` | `This is really___very___important text.` |

# Blockquotes

To create a blockquote, add a `>` in front of a paragraph.

```markdown
> Dorothy followed her through many of the beautiful rooms in her castle.
```

The rendered output looks like this:

> Dorothy followed her through many of the beautiful rooms in her castle.

## Blockquotes with Multiple Paragraphs

Blockquotes can contain multiple paragraphs. Add a `>` on the blank lines between the paragraphs.

```markdown
> Dorothy followed her through many of the beautiful rooms in her castle.
>
> The Witch bade her clean the pots and kettles and sweep the floor and keep the fire fed with wood.
```

The rendered output looks like this:

> Dorothy followed her through many of the beautiful rooms in her castle.
>
> The Witch bade her clean the pots and kettles and sweep the floor and keep the fire fed with wood.

## Nested Blockquotes

Blockquotes can be nested. Add a `>>` in front of the paragraph you want to nest.

```markdown
> Dorothy followed her through many of the beautiful rooms in her castle.
>
>> The Witch bade her clean the pots and kettles and sweep the floor and keep the fire fed with wood.
```

The rendered output looks like this:

> Dorothy followed her through many of the beautiful rooms in her castle.
>
>> The Witch bade her clean the pots and kettles and sweep the floor and keep the fire fed with wood.

## Blockquotes with Other Elements

Blockquotes can contain other Markdown formatted elements. Not all elements can be used — you’ll need to experiment to see which ones work.

```markdown
> #### The quarterly results look great!
>
> - Revenue was off the chart.
> - Profits were higher than ever.
>
>  *Everything* is going according to **plan**.
```

The rendered output looks like this:

> #### The quarterly results look great!
>
> - Revenue was off the chart.
> - Profits were higher than ever.
>
> *Everything* is going according to **plan**.

## Blockquotes Best Practices

For compatibility, put blank lines before and after blockquotes.

| ✅ Do this | Don't do this |
| --- | --- |
| Try to put a blank line before...<br><br>`> This is a blockquote`<br><br>...and after a blockquote. | Without blank lines, this might not look right.<br>`> This is a blockquote`<br>Don't do this! |

# Lists

You can organize items into ordered and unordered lists.

## Ordered Lists

To create an ordered list, add line items with numbers followed by periods. The numbers don’t have to be in numerical order, but the list should start with the number one.

| Markdown | HTML | Rendered Output |
| --- | --- | --- |
| `1. First item`<br>`2. Second item`<br>`3. Third item`<br>`4. Fourth item` | `<ol>`<br>`  <li>First item</li>`<br>`  <li>Second item</li>`<br>`  <li>Third item</li>`<br>`  <li>Fourth item</li>`<br>`</ol>` | 1. First item<br>2. Second item<br>3. Third item<br>4. Fourth item |
| `1. First item`<br>`1. Second item`<br>`1. Third item`<br>`1. Fourth item` | `<ol>`<br>`  <li>First item</li>`<br>`  <li>Second item</li>`<br>`  <li>Third item</li>`<br>`  <li>Fourth item</li>`<br>`</ol>` | 1. First item<br>2. Second item<br>3. Third item<br>4. Fourth item |
| `1. First item`<br>`8. Second item`<br>`3. Third item`<br>`5. Fourth item` | `<ol>`<br>`  <li>First item</li>`<br>`  <li>Second item</li>`<br>`  <li>Third item</li>`<br>`  <li>Fourth item</li>`<br>`</ol>` | 1. First item<br>2. Second item<br>3. Third item<br>4. Fourth item |
| `1. First item`<br>`2. Second item`<br>`3. Third item`<br>`    1. Indented item`<br>`    2. Indented item`<br>`4. Fourth item` | `<ol>`<br>`  <li>First item</li>`<br>`  <li>Second item</li>`<br>`  <li>Third item`<br>`    <ol>`<br>`      <li>Indented item</li>`<br>`      <li>Indented item</li>`<br>`    </ol>`<br>`  </li>`<br>`  <li>Fourth item</li>`<br>`</ol>` | 1. First item<br>2. Second item<br>3. Third item<br>&nbsp;&nbsp;&nbsp;&nbsp;1. Indented item<br>&nbsp;&nbsp;&nbsp;&nbsp;2. Indented item<br>4. Fourth item |

### Ordered List Best Practices

CommonMark and a few other lightweight markup languages let you use a parenthesis (`)`) as a delimiter (e.g., `1) First item`), but not all Markdown applications support this, so it isn’t a great option from a compatibility perspective. For compatibility, use periods only.

| ✅ Do this | Don't do this |
| --- | --- |
| `1. First item`<br>`2. Second item` | `1) First item`<br>`2) Second item` |

## Unordered Lists

To create an unordered list, add dashes (`-`), asterisks (`*`), or plus signs (`+`) in front of line items. Indent one or more items to create a nested list.

| Markdown | HTML | Rendered Output |
| --- | --- | --- |
| `- First item`<br>`- Second item`<br>`- Third item`<br>`- Fourth item` | `<ul>`<br>`  <li>First item</li>`<br>`  <li>Second item</li>`<br>`  <li>Third item</li>`<br>`  <li>Fourth item</li>`<br>`</ul>` | • First item<br>• Second item<br>• Third item<br>• Fourth item |
| `* First item`<br>`* Second item`<br>`* Third item`<br>`* Fourth item` | `<ul>`<br>`  <li>First item</li>`<br>`  <li>Second item</li>`<br>`  <li>Third item</li>`<br>`  <li>Fourth item</li>`<br>`</ul>` | • First item<br>• Second item<br>• Third item<br>• Fourth item |
| `+ First item`<br>`+ Second item`<br>`+ Third item`<br>`+ Fourth item` | `<ul>`<br>`  <li>First item</li>`<br>`  <li>Second item</li>`<br>`  <li>Third item</li>`<br>`  <li>Fourth item</li>`<br>`</ul>` | • First item<br>• Second item<br>• Third item<br>• Fourth item |
| `- First item`<br>`- Second item`<br>`- Third item`<br>`    - Indented item`<br>`    - Indented item`<br>`- Fourth item` | `<ul>`<br>`  <li>First item</li>`<br>`  <li>Second item</li>`<br>`  <li>Third item`<br>`    <ul>`<br>`      <li>Indented item</li>`<br>`      <li>Indented item</li>`<br>`    </ul>`<br>`  </li>`<br>`  <li>Fourth item</li>`<br>`</ul>` | • First item<br>• Second item<br>• Third item<br>&nbsp;&nbsp;&nbsp;&nbsp;• Indented item<br>&nbsp;&nbsp;&nbsp;&nbsp;• Indented item<br>• Fourth item |

### Starting Unordered List Items With Numbers

If you need to start an unordered list item with a number followed by a period, you can use a backslash (`\`) to escape the period.

| Markdown | HTML | Rendered Output |
| --- | --- | --- |
| `- 1968\. A great year!`<br>`- I think 1969 was second best.` | `<ul>`<br>`  <li>1968. A great year!</li>`<br>`  <li>I think 1969 was second best.</li>`<br>`</ul>` | • 1968. A great year!<br>• I think 1969 was second best. |

### Unordered List Best Practices

Markdown applications don’t agree on how to handle different delimiters in the same list. For compatibility, don’t mix and match delimiters in the same list — pick one and stick with it.

| ✅ Do this | Don't do this |
| --- | --- |
| `- First item`<br>`- Second item`<br>`- Third item`<br>`- Fourth item` | `- First item`<br>`* Second item`<br>`- Third item`<br>`+ Fourth item` |

## Adding Elements in Lists

To add another element in a list while preserving the continuity of the list, indent the element four spaces or one tab, as shown in the following examples.

**Tip:** If things don't appear the way you expect, double check that you've indented the elements in the list four spaces or one tab.

### Paragraphs

```markdown
* This is the first list item.
* Here's the second list item.

    I need to add another paragraph below the second list item.

* And here's the third list item.
```

The rendered output looks like this:

* This is the first list item.
* Here's the second list item.

    I need to add another paragraph below the second list item.

* And here's the third list item.

### Blockquotes

```markdown
* This is the first list item.
* Here's the second list item.

    > A blockquote would look great below the second list item.

* And here's the third list item.
```

The rendered output looks like this:

* This is the first list item.
* Here's the second list item.

    > A blockquote would look great below the second list item.

* And here's the third list item.

### Code Blocks

Code blocks are normally indented four spaces or one tab. When they’re in a list, indent them eight spaces or two tabs.

```markdown
1. Open the file.
2. Find the following code block on line 21:

        <html>
          <head>
            <title>Test</title>
          </head>

3. Update the title to match the name of your website.
```

The rendered output looks like this:

1. Open the file.
2. Find the following code block on line 21:

    ```
    <html>
      <head>
        <title>Test</title>
      </head>
    ```

3. Update the title to match the name of your website.



You can nest an unordered list in an ordered list, or vice versa.

```markdown
1. First item
2. Second item
3. Third item
    - Indented item
    - Indented item
4. Fourth item
```

The rendered output looks like this:

1. First item
2. Second item
3. Third item
    - Indented item
    - Indented item
4. Fourth item

# Code

To denote a word or phrase as code, enclose it in backticks (`` ` ``).

| Markdown | HTML | Rendered Output |
| --- | --- | --- |
| `At the command prompt, type \`nano\`.` | `At the command prompt, type <code>nano</code>.` | At the command prompt, type `nano`. |

## Escaping Backticks

If the word or phrase you want to denote as code includes one or more backticks, you can escape it by enclosing the word or phrase in double backticks (`` `` ``).

| Markdown | HTML | Rendered Output |
| --- | --- | --- |
| ``` ``Use `code` in your Markdown file.`` ``` | `<code>Use `code` in your Markdown file.</code>` | `Use `code` in your Markdown file.` |

## Code Blocks

To create code blocks, indent every line of the block by at least four spaces or one tab.

```markdown
    <html>
      <head>
      </head>
    </html>
```

The rendered output looks like this:

```html
<html>
  <head>
  </head>
</html>
```

**Note:** To create code blocks without indenting lines, use fenced code blocks.

# Horizontal Rules

To create a horizontal rule, use three or more asterisks (`***`), dashes (`---`), or underscores (`___`) on a line by themselves.

```markdown
***

---

_________________
```

The rendered output of all three looks identical:

---

## Horizontal Rule Best Practices

For compatibility, put blank lines before and after horizontal rules.

| ✅ Do this | Don't do this |
| --- | --- |
| Try to put a blank line before...<br><br>`---`<br><br>...and after a horizontal rule. | Without blank lines, this would be a heading.<br>`---`<br>Don't do this! |

# Links

To create a link, enclose the link text in brackets (e.g., `[Duck Duck Go]`) and then follow it immediately with the URL in parentheses (e.g., `(https://duckduckgo.com)`).

```markdown
My favorite search engine is [Duck Duck Go](https://duckduckgo.com).
```

The rendered output looks like this:

My favorite search engine is [Duck Duck Go](https://duckduckgo.com).

**Note:** To link to an element on the same page, see linking to heading IDs. To create a link that opens in a new tab or window, see the section on link targets.

## Adding Titles

You can optionally add a title for a link. This will appear as a tooltip when the user hovers over the link. To add a title, enclose it in quotation marks after the URL.

```markdown
My favorite search engine is [Duck Duck Go](https://duckduckgo.com "The best search engine for privacy").
```

The rendered output looks like this:

My favorite search engine is [Duck Duck Go](https://duckduckgo.com "The best search engine for privacy").

## URLs and Email Addresses

To quickly turn a URL or email address into a link, enclose it in angle brackets.

```markdown
<https://www.markdownguide.org>
<fake@example.com>
```

The rendered output looks like this:

<https://www.markdownguide.org>
<fake@example.com>

## Formatting Links

To emphasize links, add asterisks before and after the brackets and parentheses. To denote links as code, add backticks in the brackets.

```markdown
I love supporting the **[EFF](https://eff.org)**.
This is the *[Markdown Guide](https://www.markdownguide.org)*.
See the section on [`code`](#code).
```

The rendered output looks like this:

I love supporting the **[EFF](https://eff.org)**.
This is the *[Markdown Guide](https://www.markdownguide.org)*.
See the section on [`code`](#code).

## Reference-style Links

Reference-style links are a special kind of link that make URLs easier to display and read in Markdown. Reference-style links are constructed in two parts: the part you keep inline with your text and the part you store somewhere else in the file to keep the text easy to read.

### Formatting the First Part of the Link

The first part of a reference-style link is formatted with two sets of brackets. The first set of brackets surrounds the text that should appear linked. The second set of brackets displays a label used to point to the link you’re storing elsewhere in your document.

Although not required, you can include a space between the first and second set of brackets. The label in the second set of brackets is not case sensitive and can include letters, numbers, spaces, or punctuation.

This means the following example formats are roughly equivalent for the first part of the link:

```markdown
[hobbit-hole][1]
[hobbit-hole] [1]
```

### Formatting the Second Part of the Link

The second part of a reference-style link is formatted with the following attributes:

- The label, in brackets, followed immediately by a colon and at least one space (e.g., `[label]: `).
- The URL for the link, which you can optionally enclose in angle brackets.
- The optional title for the link, which you can enclose in double quotes, single quotes, or parentheses.

This means the following example formats are all roughly equivalent for the second part of the link:

```markdown
[1]: https://en.wikipedia.org/wiki/Hobbit#Lifestyle
[1]: https://en.wikipedia.org/wiki/Hobbit#Lifestyle "Hobbit lifestyles"
[1]: https://en.wikipedia.org/wiki/Hobbit#Lifestyle 'Hobbit lifestyles'
[1]: https://en.wikipedia.org/wiki/Hobbit#Lifestyle (Hobbit lifestyles)
[1]: <https://en.wikipedia.org/wiki/Hobbit#Lifestyle> "Hobbit lifestyles"
[1]: <https://en.wikipedia.org/wiki/Hobbit#Lifestyle> 'Hobbit lifestyles'
[1]: <https://en.wikipedia.org/wiki/Hobbit#Lifestyle> (Hobbit lifestyles)
```

You can place this second part of the link anywhere in your Markdown document. Some people place them immediately after the paragraph in which they appear while other people place them at the end of the document (like endnotes or footnotes).

### An Example Putting the Parts Together

Say you add a URL as a standard URL link to a paragraph and it looks like this in Markdown:

```markdown
In a hole in the ground there lived a hobbit. Not a nasty, dirty, wet hole, filled with the ends
of worms and an oozy smell, nor yet a dry, bare, sandy hole with nothing in it to sit down on or to
eat: it was a [hobbit-hole](https://en.wikipedia.org/wiki/Hobbit#Lifestyle "Hobbit lifestyles"), and that means comfort.
```

Though it may point to interesting additional information, the URL as displayed really doesn’t add much to the existing raw text other than making it harder to read. To fix that, you could format the URL like this instead:

```markdown
In a hole in the ground there lived a hobbit. Not a nasty, dirty, wet hole, filled with the ends
of worms and an oozy smell, nor yet a dry, bare, sandy hole with nothing in it to sit down on or to
eat: it was a [hobbit-hole][1], and that means comfort.

[1]: <https://en.wikipedia.org/wiki/Hobbit#Lifestyle> "Hobbit lifestyles"
```

In both instances above, the rendered output would be identical:

> In a hole in the ground there lived a hobbit. Not a nasty, dirty, wet hole, filled with the ends of worms and an oozy smell, nor yet a dry, bare, sandy hole with nothing in it to sit down on or to eat: it was a [hobbit-hole](https://en.wikipedia.org/wiki/Hobbit#Lifestyle "Hobbit lifestyles"), and that means comfort.

and the HTML for the link would be:

```html
<a href="https://en.wikipedia.org/wiki/Hobbit#Lifestyle" title="Hobbit lifestyles">hobbit-hole</a>
```

## Link Best Practices

Markdown applications don’t agree on how to handle spaces in the middle of a URL. For compatibility, try to URL encode any spaces with `%20`. Alternatively, if your Markdown application supports HTML, you could use the `a` HTML tag.

| ✅ Do this | Don't do this |
| --- | --- |
| `[link](https://www.example.com/my%20great%20page)`<br><br>`<a href="https://www.example.com/my great page">link</a>` | `[link](https://www.example.com/my great page)` |

Parentheses in the middle of a URL can also be problematic. For compatibility, try to URL encode the opening parenthesis (`(`) with `%28` and the closing parenthesis (`)`) with `%29`. Alternatively, if your Markdown application supports HTML, you could use the `a` HTML tag.

| ✅ Do this | Don't do this |
| --- | --- |
| `[a novel](https://en.wikipedia.org/wiki/The_Milagro_Beanfield_War_%28novel%29)`<br><br>`<a href="https://en.wikipedia.org/wiki/The_Milagro_Beanfield_War_(novel)">a novel</a>` | `[a novel](https://en.wikipedia.org/wiki/The_Milagro_Beanfield_War_(novel))` |
zs
# Escaping Characters

To display a literal character that would otherwise be used to format text in a Markdown document, add a backslash (`\`) in front of the character.

```markdown
\* Without the backslash, this would be a bullet in an unordered list.
```

The rendered output looks like this:

\* Without the backslash, this would be a bullet in an unordered list.

## Characters You Can Escape

You can use a backslash to escape the following characters.

| Character | Name |
| --- | --- |
| `\` | backslash |
| `` ` `` | backtick (see also escaping backticks in code) |
| `*` | asterisk |
| `_` | underscore |
| `{ }` | curly braces |
| `[ ]` | brackets |
| `< >` | angle brackets |
| `( )` | parentheses |
| `#` | pound sign |
| `+` | plus sign |
| `-` | minus sign (hyphen) |
| `.` | dot |
| `!` | exclamation mark |
| `\|` | pipe (see also escaping pipe in tables) |

# HTML

Many Markdown applications allow you to use HTML tags in Markdown-formatted text. This is helpful if you prefer certain HTML tags to Markdown syntax. For example, some people find it easier to use HTML tags for images. Using HTML is also helpful when you need to change the attributes of an element, like specifying the color of text or changing the width of an image.

To use HTML, place the tags in the text of your Markdown-formatted file.

```markdown
This **word** is bold. This <em>word</em> is italic.
```

The rendered output looks like this:

This **word** is bold. This <em>word</em> is italic.

## HTML Best Practices

For security reasons, not all Markdown applications support HTML in Markdown documents. When in doubt, check your Markdown application’s documentation. Some applications support only a subset of HTML tags.

Use blank lines to separate block-level HTML elements like `<div>`, `<table>`, `<pre>`, and `<p>` from the surrounding content. Try not to indent the tags with tabs or spaces — that can interfere with the formatting.

You can’t use Markdown syntax inside block-level HTML tags. For example, `<p>italic and **bold**</p>` won’t work.
