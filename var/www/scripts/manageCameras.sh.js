var repositoryURL="https://github.com/jmirasb/opendomo-vision/";
$("#submit-saveSettings").on("click",function(e){
	e.preventDefault();
	$("#manageCameras li.filter").each(function(){
		$(this).addClass("loading");
		if ($(this).hasClass("selected")){
			var filter = $(this).id;
			var camera = $("#code");
			loadAsync("./addFilterToCamera.sh?camera="+camera+"&filter="+filter,function(){
				console.log("Saved "+filter);
			});
		} else {
			var filter = $(this).id;
			var camera = $("#code");
			loadAsync("./removeFilterToCamera.sh?camera="+camera+"&filter="+filter,function(){
				console.log("Saved "+filter);
			});			
		}
		$(this).removeClass("loading");		
	});
});
