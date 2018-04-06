var niw = {
    init: function () {
        $('.modal').on('show.bs.modal', function () { $('.content').css({ '-webkit-display': 'block', 'display': 'block' }); });
        //$('.modal').on('hide.bs.modal', function () { $('.content').css({ '-webkit-display': 'flex', 'display': 'flex' }); });
        $('.modal').on('hide.bs.modal', function () { if ($('.modal-backdrop').length == 1 && $(window).width() >= 992) $('.content').css({ '-webkit-display': 'flex', 'display': 'flex' }); });
    },
    ajax: function (data, successCallback, errorCallback) {
        if (errorCallback == undefined)
            errorCallback = null;
        $.ajax({
            method: "POST",
            url: window.location.pathname,
            data: data,
            success: function (msg) { successCallback(msg); },
            error: function (msg) { failureCallback(msg); }
        });
        function failureCallback(err) {
            dialogs.alert("Error de Conexión.",errorCallback,"Error","Aceptar","iGdanger");
        }
    },
    simplifyBtns: function () {
        return false;
    },
    listSearchFilter: function (boxFinder) {
        var searchFinder = {
            keyUp: function (e) {
                var kp = e.keyCode;
                if (kp != 16 && kp != 17 && kp != 18 && kp != 91 && kp != 93 && kp != 13) {
                    var bf = $(boxFinder + ' .searchField');
                    bf.hide();
                    bf.find('h5:contains(' + $(this).val() + ')').parents('li').show();
                }
            }
        };
        var sInput = $(boxFinder + ' li:eq(0)').find('input');
        sInput.keyup(searchFinder.keyUp);
    },
    tableSearchFilter: function (boxFinder) {
        var searchFinder = {
            keyUp: function (e) {
                var kp = e.keyCode;
                if (kp != 16 && kp != 17 && kp != 18 && kp != 91 && kp != 93 && kp != 13) {
                    var bf = $(boxFinder + ' .searchField');
                    bf.hide();
                    bf.find('td:contains(' + $(this).val() + ')').parents('tr').show();
                }
            }
        };
        var sInput = $(boxFinder + ' tr:eq(0)').find('input');
        sInput.keyup(searchFinder.keyUp);
    }
};
$(niw.init);