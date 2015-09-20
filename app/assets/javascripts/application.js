// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require semantic-ui
//= require turbolinks
//= require_tree .
//= require_self

$(document).ready(function() {
	$('select.dropdown').dropdown();

	$('#post_image').change(function() {
		$('#post_title').prop('disabled', true);
	});

	$('#blog_id').change(updateBlog);
	$(document).ready(updateBlog);

	$('#submit, #draft').on('click', function() {
		combined = $('#post_pre_body').val() + '\n\n' + $('#post_body').val();
	  $('#post_body').empty().val(combined);
	});

	function updateBlog() {
		var id = $('select#blog_id :selected').val();
		$.ajax({
			url: 'interactions/change_blog',
			data: {'blog_id': id },
			success: function(data) { 
				$('#list').empty();
				$('#count').empty().append(data.count);
				$('post_body').empty();
				var string = '';
				data.followers.forEach(function(f) {
					$('#list').append("<li>" + f.name + "</li>");
					string += '<a spellcheck="false" class="tumblelog">' + f.name + '</a> ';
				});
				$('#post_body').val(string);
			}
		});
	}
	return false;
});

