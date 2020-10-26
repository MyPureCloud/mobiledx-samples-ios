<style>
img {
    max-width: 100% !important;
height: auto !important;
}

body {
    font-family: Roboto-Regular;
    color: #6c6c6c;
}

table
{
    table-layout: fixed;
    max-width: none;
    width: auto;
    min-width: 100%;
    border: solid thin;
}

td {
    border: solid thin;
}

tbody {
    border: solid thin;
}

@media (prefers-color-scheme: dark) {
    html{
        filter: invert(1)  hue-rotate(.5turn);
    }
    img {
        filter: invert(1)  hue-rotate(.5turn);
    }
}

</style>
<script>
document.addEventListener('DOMContentLoaded', function () {
    window.webkit.messageHandlers.callback.postMessage({"status":"ready"});
}, false);

function updateUI(config) {
    if(config.textColor) {
        document.body.style.color = config.textColor;
    }

    if(config.fontName.length) {
        document.body.style.fontFamily = config.fontName;
    }
    
    if(config.fontSize) {
        document.body.style.fontSize = config.fontSize;
    }
}

(function() {
 var embeds = document.querySelectorAll('iframe');
 for (var i = 0, embed, content, width, height, ratio, wrapper; i < embeds.length; i++) {
 embed = embeds[i];
 width = embed.getAttribute('width'),
 height = embed.getAttribute('height')
 ratio = width / height;

 // skip frames with relative dimensions
 if (isNaN(ratio)) continue;

 // set wrapper styles
 wrapper = document.createElement('div');
 wrapper.style.position = 'relative';
 wrapper.style.width = width.indexOf('%') < 0 ? parseFloat(width) + 'px' : width;
 wrapper.style.maxWidth = '100%';

 // set content styles
 content = document.createElement('div');
 content.style.paddingBottom = 100 / ratio + '%';

 // set embed styles
 embed.style.position = 'absolute';
 embed.style.width = '100%';
 embed.style.height = '100%';

 // update DOM structure
 embed.parentNode.insertBefore(wrapper, embed);
 content.appendChild(embed);
 wrapper.appendChild(content);
 }
 }());
</script>
<script>
    var links = document.querySelectorAll("a[nanorepLinkId]");

    for (var i = 0; i < links.length; i++) {
        var link = links[i];

        var id = link.getAttribute('nanorepLinkId');
        var linkMode = link.getAttribute('nanoreplinkmode');
    
        link.href = "nanorep://linkedArticle?answerId="+ id;
        if (linkMode != null) {
            linkMode = linkMode == 'context' ? 'true': 'false';
            link.href += "&getAnswerByContext=" + linkMode + "&src=Link";
        }
}
</script>
