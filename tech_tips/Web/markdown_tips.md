
### [Main Tips Page](https://github.com/sethfuller/tips/blob/main/tech_tips/README.md)



|                                                                              |                                                                                      |
|------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| [Markdown Docs](https://www.markdownguide.org/)                              | [Github Flavored Markdown (GFM) Docs](https://github.github.com/gfm/)                |
| [Chrome Markdown Viewer Extension](https://github.com/simov/markdown-viewer) | [Emacs Wiki Markdown Mode](https://www.emacswiki.org/emacs/MarkdownMode)             |
| [Emacs Markdown Mode Manual](https://leanpub.com/markdown-mode/read)         | [Emacs Markdown Mode By Jason Blevins](https://jblevins.org/projects/markdown-mode/) |
|                                                                              |                                                                                      |

### Script

```html
<script>
// This doesn't work because HTML is generated after page load 
function otherTabLink() {
	var links = document.links;

	for (var i = 0, linksLength = links.length; i < linksLength; i++) {
		if (links[i].hostname != window.location.hostname) {
			links[i].target = '_blank';
		}
		console.log("Link: ", links[i].hostname);
	}
}
document.onload = otherTabLink();

</script>
```

### Internal Link
Place in page to link to go to:

```html
<a name="top"></a>
```

Refer to link:

```markdown
[Top](#top)
```

----------

### [Main Tips Page](https://github.com/sethfuller/tips/blob/main/tech_tips/README.md)

