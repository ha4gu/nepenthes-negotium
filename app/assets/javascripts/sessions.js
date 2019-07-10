window.addEventListener("load", function(){
    document.querySelectorAll('.alert-dismissible').forEach(function(alert) {
        alert.addEventListener('ajax:success', function(event) {
            alert.classList.add('fadeout');
            setTimeout(function(){
                alert.parentNode.removeChild(alert);
            }, 500);
        }, false);
    });
}, false);
