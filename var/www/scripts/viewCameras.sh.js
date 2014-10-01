
setInterval(refreshCameras,5000);

function refreshCameras() {
	$("li.camera").each(function(index){
		var filename = "/data/" + $(this).attr("id")  + ".jpeg";
		$(this).find("a").css("background-image","url('" + filename + "');")
	});
}