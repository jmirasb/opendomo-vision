
setInterval(refreshCameras,5000);

function refreshCameras() {
	$("li.camera").each(function(index){
		var filename = "/data/" + $(this).attr("id")  + ".jpeg";
		$(this).find("a").css("background","url(" + filename + ") no-repeat center center");
	});
}