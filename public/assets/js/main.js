(function ($) {
  "use strict";

  /*
  |--------------------------------------------------------------------------
  | Template Name: Multim
  | Author: Laralink
  | Version: 1.0.0
  |--------------------------------------------------------------------------
  |--------------------------------------------------------------------------
  | TABLE OF CONTENTS:
  |--------------------------------------------------------------------------
  |
  | 1. Preloader
  | 2. Mobile Menu
  | 3. Sticky Header
  | 4. Dynamic Background
  | 5. General Toggle
  | 6. Select 2
  | 7. Slick Slider
  | 9. Review
  | 11. Modal Video
  | 12. Hobble Effect
  | 13. Parallax
  | 14. Counter Animation
  | 15. Tabs
  | 17. Progress Bar
  | 18. Team Member
  | 20. Round Percent
  | 21. Range slider
  |
  */

  /*--------------------------------------------------------------
    Scripts initialization
  --------------------------------------------------------------*/
  $.exists = function (selector) {
    return $(selector).length > 0;
  };

  $(window).on("load", function () {
    $(window).trigger("scroll");
    $(window).trigger("resize");
    preloader();
  });

  $(function () {
    $(window).trigger("resize");
    mainNav();
    onePage();
    stickyHeader();
    dynamicBackground();
    slickInit();
    modal();
    accordian();
    counterInit();
    rippleInit();
    if ($.exists(".wow")) {
      new WOW().init();
    }
  });

  $(window).on("scroll", function () {
    stickyHeader();
    counterInit()
  });

  /*--------------------------------------------------------------
    1. Preloader
  --------------------------------------------------------------*/
  function preloader() {
    $(".cs-preloader_in").fadeOut();
    $(".cs-preloader").delay(150).fadeOut("slow");
  }

  /*--------------------------------------------------------------
    2. Mobile Menu
  --------------------------------------------------------------*/
  function mainNav() {
    $(".cs-nav").append('<span class="cs-munu_toggle"><span></span></span>');
    $(".menu-item-has-children").append(
      '<span class="cs-munu_dropdown_toggle"></span>'
    );
    $(".cs-munu_toggle").on("click", function () {
      $(this)
        .toggleClass("cs-toggle_active")
        .siblings(".cs-nav_list")
        .slideToggle();
    });
    $(".cs-munu_dropdown_toggle").on("click", function () {
      $(this).toggleClass("active").siblings("ul").slideToggle();
      $(this).parent().toggleClass("active");
    });
    // Mega Menu
    $(".cs-mega-wrapper>li>a").removeAttr("href");
    // Modal Btn
    $('.cs-mode_btn').on('click', function() {
      $(this).toggleClass('active');
      $('body').toggleClass('cs-dark');
    })
  }

  // Smoth Animated Scroll
  function onePage() {
    $(".cs-smoth_scroll").on("click", function () {
      var thisAttr = $(this).attr("href");
      if ($(thisAttr).length) {
        var scrollPoint = $(thisAttr).offset().top - 40;
        $("body,html").animate(
          {
            scrollTop: scrollPoint,
          },
          600
        );
      }
      return false;
    });
  }

  /*--------------------------------------------------------------
    3. Sticky Header
  --------------------------------------------------------------*/
  function stickyHeader() {
    var scroll = $(window).scrollTop();
    if (scroll >= 10) {
      $(".cs-sticky-header").addClass("cs-sticky-active");
    } else {
      $(".cs-sticky-header").removeClass("cs-sticky-active");
    }
  }

  /*--------------------------------------------------------------
    4. Dynamic Background
  --------------------------------------------------------------*/
  function dynamicBackground() {
    $("[data-src]").each(function () {
      var src = $(this).attr("data-src");
      $(this).css({
        "background-image": "url(" + src + ")",
      });
    });
  }

  /*--------------------------------------------------------------
    7. Slick Slider
  --------------------------------------------------------------*/
  function slickInit() {
    if ($.exists(".cs-slider")) {
      $(".cs-slider").each(function () {
        // Slick Variable
        var $ts = $(this).find(".cs-slider_container");
        var $slickActive = $(this).find(".cs-slider_wrapper");

        // Auto Play
        var autoPlayVar = parseInt($ts.attr("data-autoplay"), 10);
        // Auto Play Time Out
        var autoplaySpdVar = 3000;
        if (autoPlayVar > 1) {
          autoplaySpdVar = autoPlayVar;
          autoPlayVar = 1;
        }
        // Slide Change Speed
        var speedVar = parseInt($ts.attr("data-speed"), 10);
        // Slider Loop
        var loopVar = Boolean(parseInt($ts.attr("data-loop"), 10));
        // Slider Center
        var centerVar = Boolean(parseInt($ts.attr("data-center"), 10));
        // Slider Center
        var variableWidthVar = Boolean(
          parseInt($ts.attr("data-variable-width"), 10)
        );
        // Pagination
        var paginaiton = $(this).find(".cs-pagination").hasClass("cs-pagination");
        // Slide Per View
        var slidesPerView = $ts.attr("data-slides-per-view");
        if (slidesPerView == 1) {
          slidesPerView = 1;
        }
        if (slidesPerView == "responsive") {
          var slidesPerView = parseInt($ts.attr("data-add-slides"), 10);
          var lgPoint = parseInt($ts.attr("data-lg-slides"), 10);
          var mdPoint = parseInt($ts.attr("data-md-slides"), 10);
          var smPoint = parseInt($ts.attr("data-sm-slides"), 10);
          var xsPoing = parseInt($ts.attr("data-xs-slides"), 10);
        }
        // Fade Slider
        var fadeVar = parseInt($($ts).attr("data-fade-slide"));
        fadeVar === 1 ? (fadeVar = true) : (fadeVar = false);

        // Slick Active Code
        $slickActive.slick({
          autoplay: autoPlayVar,
          dots: paginaiton,
          centerPadding: "7%",
          speed: speedVar,
          infinite: loopVar,
          autoplaySpeed: autoplaySpdVar,
          centerMode: centerVar,
          fade: fadeVar,
          prevArrow: $(this).find(".cs-left_arrow"),
          nextArrow: $(this).find(".cs-right_arrow"),
          appendDots: $(this).find(".cs-pagination"),
          slidesToShow: slidesPerView,
          variableWidth: variableWidthVar,
          slidesToScroll: slidesPerView,
          responsive: [
            {
              breakpoint: 1600,
              settings: {
                slidesToShow: lgPoint,
                slidesToScroll: lgPoint,
              },
            },
            {
              breakpoint: 1200,
              settings: {
                slidesToShow: mdPoint,
                slidesToScroll: mdPoint,
              },
            },
            {
              breakpoint: 992,
              settings: {
                slidesToShow: smPoint,
                slidesToScroll: smPoint,
              },
            },
            {
              breakpoint: 768,
              settings: {
                slidesToShow: xsPoing,
                slidesToScroll: xsPoing,
              },
            },
          ],
        });
      });
    }
  }

  /*--------------------------------------------------------------
    11. Modal Video
  --------------------------------------------------------------*/
  function modal() {
    $(".cs-modal_btn").on('click', function() {
      var modalData = $(this).attr("data-modal") 
      $(`[data-modal='${modalData}']`).addClass('active')
    })
    $(".cs-close_modal").on('click', function() {
      var modalData = $(this).parents('.cs-modal').attr("data-modal") 
      $(`[data-modal='${modalData}']`).removeClass('active')
    })
  }

  /*--------------------------------------------------------------
    16. Accordian
  --------------------------------------------------------------*/
  function accordian() {
    $(".cs-accordian").children(".cs-accordian-body").hide();
    $(".cs-accordian.active").children(".cs-accordian-body").show();
    $(".cs-accordian_head").on("click", function () {
      $(this).parent(".cs-accordian").siblings().children(".cs-accordian-body").slideUp(250);
      $(this).siblings().slideDown(250);
      $(this).parent().parent().siblings().find(".cs-accordian-body").slideUp(250);
      /* Accordian Active Class */
      $(this).parents(".cs-accordian").addClass("active");
      $(this).parent(".cs-accordian").siblings().removeClass("active");
    });
  }

  /*--------------------------------------------------------------
    14. Counter Animation
  --------------------------------------------------------------*/
  function counterInit() {
    if ($.exists(".odometer")) {
      $(window).on("scroll", function () {
        function winScrollPosition() {
          var scrollPos = $(window).scrollTop(),
            winHeight = $(window).height();
          var scrollPosition = Math.round(scrollPos + winHeight / 1.2);
          return scrollPosition;
        }

        $(".odometer").each(function () {
          var elemOffset = $(this).offset().top;
          if (elemOffset < winScrollPosition()) {
            $(this).html($(this).data("count-to"));
          }
        });
      });
    }
  }

  /*--------------------------------------------------------------
    20. Ripple
  --------------------------------------------------------------*/
  function rippleInit() {
    if ($.exists('.cs-ripple_version')) {
      $('.cs-ripple_version').each(function () {
        $('.cs-ripple_version').ripples({
          resolution: 512,
          dropRadius: 20,
          perturbance: 0.04,
        });
      });
    }
  }


})(jQuery); // End of use strict
