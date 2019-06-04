function loadScript(url, callback) {
    // Adding the script tag to the head as suggested before
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = url;
    
    // Then bind the event to the callback function.
    // There are several events for cross browser compatibility.
    script.onreadystatechange = callback;
    script.onload = callback;

    //window.webkit.messageHandlers.reCaptchaiOS.postMessage([head]);
    // Fire the loading
    document.body.appendChild(script);
};

var showCaptcha = function() {
    var RECAPTCHA_SITE_KEY = '%@';
    var PAGE_BG_COLOR = '#ffffff';
    
    function waitReady() {
        if (document.readyState == 'complete')
            documentReady();
        else
            setTimeout(waitReady, 100);
    }
  
    function documentReady() {
        while (document.body.lastChild)
            document.body.removeChild(document.body.lastChild);
  
        var div = document.createElement('div');
  
        div.style.position = 'absolute';
        div.style.left = 'calc(50% - 151px)';
        div.style.top = 'calc(50% - 50px)';
        document.body.style.backgroundColor = PAGE_BG_COLOR;
        document.body.appendChild(div);
  
        var meta = document.createElement('meta');
  
        meta.setAttribute('name', 'viewport');
        meta.setAttribute('content', 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0');
  
        document.head.appendChild(meta);
  
        renderCaptcha(div);
    }
  
    function renderCaptcha(el) {
        try {
            grecaptcha.render(el, {
                                    'sitekey': RECAPTCHA_SITE_KEY,
                                    'callback': captchaSolved,
                                    'expired-callback': captchaExpired,
                                    });
            
            window.webkit.messageHandlers.reCaptchaiOS.postMessage(["didLoad"]);
        } catch (e) {
            window.webkit.messageHandlers.reCaptchaiOS.postMessage([e.message]);
        }
    }
  
    function captchaSolved(response) {
        window.webkit.messageHandlers.reCaptchaiOS.postMessage(["didSolve", response]);
    }
  
    function captchaExpired(response) {
        window.webkit.messageHandlers.reCaptchaiOS.postMessage(["didExpire"]);
    }
  
    waitReady();
 };

loadScript("https://www.google.com/recaptcha/api.js", showCaptcha);

