jQuery(function($){
    if (document.forms.search) {
        $(document.forms.search).placeholder();
    }

    if (document.forms.comments) {
        $(document.forms.comments).placeholder();
    }

    $('#cmt-form').click(function(e) {
        var that = e.target;

        if (!$.nodeName(that, 'a') || $(that).find('form').size()) {
            return true;
        }
        e.preventDefault();

        var form = document.forms.comments;
        form['comment[reply]'].value = '';
        $(form).removeClass('reply-form')
            .insertAfter(that.parentNode);
    })

    $('#comments').click(function(e) {
        var that = e.target;

        if (!$.nodeName(that, 'a') || !$(that).hasClass('small-btn')) {
            return true;
        }
        e.preventDefault();

        var id = Number(that.href.substr(that.href.lastIndexOf('#') + 1));
        if (!id) {
            return true;
        }

        var form = document.forms.comments;
        form['comment[reply]'].value = id;
        $(form).addClass('reply-form')
            .insertAfter($(that.parentNode.parentNode).next());
    });

    $('#question').click(hideThenShow);
    $(document.vote).submit(function(e){
        if (this.voted || !$(this).find('input:checked').size()) {
            return false;
        }
        e.preventDefault();

        // div.box
        $(this.parentNode.parentNode.parentNode).addClass('loading');
        $.ajax({
            type: 'POST',
            url: $(this).attr('action'),
            dataType: 'json',
            data: $(this).serialize(),
            context: this,
            success:function(data){
                var id = $(this).find('input:checked').val(), span = $('#vote_answer_' + id),
                    hits = Number(span.text()) || 0;

                if (data.notice) {
                    span.text(hits + 1);
                    this.voted = true;
                }
                hideThenShow({
                    target: $('a[name]', this)[0]
                });
                $(this.parentNode.parentNode.parentNode).removeClass('loading');
            }
        });
    });

    $('#content form div.tip').delay(4000).fadeOut(1000);

    var box = $('#content div.sidebar div.banner-fixed'),
        top = box.offset().top - parseFloat(box.css('marginTop').replace(/auto/, 0));

    $(window).scroll(function(){
        var windowpos = $(window).scrollTop();
        if(windowpos < top) {
            box.css('position', 'static');
        } else {
            box.css('position', 'fixed');
            box.css('top', '5px');
        }
    });//*/
})

jQuery.fn.placeholder = function() {
    this.mousedown(function(e) {
        var that = e.target;
        if (!$.nodeName(that, 'label')) {
            return true;
        }
        var inp = $(that).next()[0];
        if (!$.trim(inp.value) || inp.type == 'password') {
            $(that).hide();
            setTimeout(function(){
                inp.focus();
            }, 10);
        }
    }).find('label').each(function() {
        var that = $(this);
        if (that.next().val()) {
            that.hide();
        }
    });

    this.find('input[type="text"], input[type="password"]').blur(function(e) {
        if (!$.trim(this.value)) {
            $(this).prev().show();
        }
    }).focus(function(e) {
        if (!$.trim(this.value) || this.type == 'password') {
            $(this).prev().hide();
        }
    })
    return this;
};

function hideThenShow(e) {
    var that = e.target, $ = window.jQuery;

    if (!$.nodeName(that, 'a') || !that.name) {
        return true;
    }

    if (e.preventDefault) {
        e.preventDefault();
    }
    $(that.parentNode.parentNode).addClass('hidden')[that.name]()
        .removeClass('hidden')
}
