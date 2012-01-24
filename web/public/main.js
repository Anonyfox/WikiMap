$(document).ready(function() {
	$('button').button();
});

function wiki_ask() {
	var query = $('#search').val();
	$.get("/ask?query="+query, function (data) {
		$('#options_list').html(data);
	})
}

function wiki_get(query) {
	$.get("/get?query="+encodeURI(query), function (data) {
		$('#options_list').html(data);
	})
}
