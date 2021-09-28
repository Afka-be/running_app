$( document ).ready(function() {
    $('a[href="#shiny-tab-running"]').click(function(){
        $(".ui.dashboard-sidebar").css("background", "url('../images/sport-bg.png')")
    });
    $('a[href="#shiny-tab-biking"]').click(function(){
        $(".ui.dashboard-sidebar").css("background", "url('../images/bike-bg.png')")
    });
});

