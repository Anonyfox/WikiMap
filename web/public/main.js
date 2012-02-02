$(document).ready(function() {
	style_page();
	load_abouts();
});

function style_page() {
	$('button').button();
	$('button').css("line-height", "0px");
	$('#options_list').fadeOut(0);
	$('#mindmap').fadeOut(0);
	$('#search').focus();
	$('#about_box').dialog({
		modal: true,
		height: 400,
		width: 600,
		autoOpen: false,
		buttons: {
			Ok: function() { $( this ).dialog( "close" ); }
		}
	});
	$('#search').bind("keypress", function (e) {
		if(e.keyCode==13){
    	wiki_ask();
    }
	})
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

function show_abouts() {
	$('#about_box').dialog("open");
}

function get_file() {
	window.location = "/download";
}