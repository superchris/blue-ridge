
(function($) {


  $(Screw).bind("after", function(){
    var testCount = $('.passed').length + $('.failed').length;
    var failures = $('.failed').length;

    $(".failed").each(function(index, elem) {
        var context_name = $(elem).parents(".describe").children("h1").text();
        var example_name = $(elem).children("h2").text();
        $('body').append("<spand id='failure_" + index + "'>" +
            context_name + " - " + example_name + "</span>");
    });

    $('body').append("<span id='test_count'>" + testCount + "</span>");
    $('body').append("<span id='test_failures'>" + failures + "</span>");

  });
})(jQuery);
