$(document).ready(function() {
	style_page();
});

function style_page() {
	$('button').button();
	$('button').css("line-height", "0px");
	$('#options_list').fadeOut(0);
	$('#mindmap').fadeOut(0);
	$('#search').focus();
}

function wiki_ask() {
	$('#mindmap').fadeOut(400, function () {
		$('#options_list').fadeIn(400);
	});
	var query = $('#search').val();
	$.get("/ask?query="+encodeURI(query), function (data) {
		$('#options_list').html(data);
	})
}

function wiki_get(query) {
	set_line(query);
	var mm_div = $('#mindmap');
	mm_div.html("&nbsp;");
	$('#options_list').fadeOut(400, function () {
		$('#mindmap').fadeIn(400);	
	});
	$.get("/get_mm_data?query="+encodeURI(query), function (data) {
		$('#mindmap').jQCloud(eval(data));
	})
}

function set_line(text) {
	$('#search').val(text);
}

function get_randoms() {
	$('#mindmap').fadeOut(400, function () {
		$('#options_list').fadeIn(400);
	});
	set_line("");
	$.get("/get_random_pages", function (data) {
		$('#options_list').html(data);
	})
}

function load_abouts() {
	$.get("/about", function (data) {
		$('#about_box').html(data);
	})
}