$(document).on('turbolinks:load', function() {
  if ($(document).find(".movies_list").length == 1)
  {
    $(document).ready(function() {

      var page = 1;
      var rating = null;
      var year = null;
      var url = $('#url').data('url')
      var search = null;
      var datas = $('#movie_count').text();

      categories = {
        "Action": false,
        "Adventure": false,
        "Animation": false,
        "Biography": false,
        "Comedy": false,
        "Crime": false,
        "Documentary": false,
        "Drama": false,
        "Family": false,
        "Fantasy": false,
        "Film-Noir": false,
        "Game-Show": false,
        "History": false,
        "Music": false,
        "Horror": false,
        "Musical": false,
        "Mystery": false,
        "News": false,
        "Reality-TV": false,
        "Sci-Fi": false,
        "Sport": false,
        "Talk-Show": false,
        "Thriller": false,
        "War": false,
        "Western": false,
      }

      // ===========================================================================

      function cal_api(url)
      {
          params = current_params(url)
          console.log("1 : " + url + params + " || " + datas + " || page = " + page)
          $.ajax({
            url: url + params,
            success: function(data) {
                $( "#movie_count").html( data['data']['movie_count'])
                datas = $('#movie_count').text();
                if (datas != "0") {
               $( "#movie" ).tmpl( data['data']['movies'] )
                    .appendTo( "#contain_movies" );
               }

            }
          });
      }

      function current_params(url)
      {
          params = ""
          if (rating || search || year) {
              params += "&sort_by=title&order_by=asc";
          }
          $.each( categories, function( index, value ) {
              if (value == true)
              {
                params += "&sort_by=title&order_by=asc&genre=" + index
              }
          });
          if (rating)
          {
              params += "&minimum_rating=" + rating
          }
          if (search)
          {
              params += "&query_term=" + search
          }
          if (year)
          {
              params += "&query_term=" + year
          }
          params += "&page=" + page
          set_params_to_page(url, params);
          return params
      }

      function set_params_to_page(url, current_params)
      {
        window.history.pushState('page2', 'Title', "?page=" + page + current_params);
      }

      // ===========================================================================

      $("#title").on("change paste keyup", function() {
        search = $(this).val();
        if (search == "") {
          search = null;
        }
        else {
          $("#contain_movies").empty();
          page = 1;
        }
        cal_api(url);
      });

      $(".rating").on("change paste keyup", function() {
        value = $( ".rating option:selected" ).text();
        rating = value;
        page = 1;
        $("#contain_movies").empty();
        if (rating == "0") {
            rating = null;
        }
        console.log("rate " + value);
        cal_api(url);
      });


      $(".date_min").on("change paste keyup", function() {
        value = $( ".date_min option:selected" ).text();
        $("#contain_movies").empty();
        if (value != '---') {
            year = value;
        }
        else {
            year = null;
        }
        cal_api(url);
        console.log("date" + value);
      });

    //   $(".date_max").on("change paste keyup", function() {
    //     value = $( ".date_max option:selected" ).text();
    //     console.log("date" + value);
    //   });

      $( ".categories" ).click(function(event) {
        name = jQuery(this).attr("id")
        if (categories[name] == true) {
          categories[name] = false
        }
        else {
          categories[name] = true
        }
        $("#contain_movies").empty();
        page = 1;
        cal_api(url);
      });


      // ===========================================================================

      $(window).scroll(function() {
        if ($(window).scrollTop() === $(document).height() - $(window).height()) {
          if ($(document).find(".movies_list").length == 1)
          {
              if (!(page + 1 > parseInt(datas) / 24 + 1)) {
                  page = parseInt(page) + 1;
                  console.log("page = " + page + " || datas = " + datas);
                  cal_api(url);
              }
          }
        }
      });

    });



  }
})
