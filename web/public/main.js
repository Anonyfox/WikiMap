$(document).ready(function() {
	style_page();
});

function style_page() {
	$('button').button();
	$('#options_list').fadeOut("fast");
	$('#mindmap').fadeOut("fast");
}

function wiki_ask() {
	$('#options_list').fadeIn("fast");
	$('#mindmap').fadeOut("fast");
	var query = $('#search').val();
	$.get("/ask?query="+encodeURI(query), function (data) {
		$('#options_list').html(data);
	})
}

function wiki_get(query) {
	/*
	$.get("/get?query="+encodeURI(query), function (data) {
		$('#options_list').html(data);
	})
	*/
	mm_get(query);
}

function mm_get(query) {
	$('#options_list').fadeOut("fast");
	var mm_div = $('#mindmap');
	mm_div.html("");
	mm_div.fadeIn("fast");
	$.get("/get_mm_data?query="+encodeURI(query), function (data) {
		mm_div.jQCloud(eval(data));
	})
}