<div class="manufacture-box backgound-darkgray" mtitle="Manufacturers">
	<a href="#Market/model?manufacturer_id=[:id]" module="SELECT_MANUFACTURER" class="ui-corner-all">
		[:when (IEVERSION(8) == false)]{
			<div class="manufacture-box-image-box-normal" style="background-image:url(images/manufacturers/[:label]_logo.png);"></div>
			<div class="manufacture-box-image-box-gray" style="background-image:url(images/manufacturers/[:label]_glogo.png);"></div>
		}
		[:when (IEVERSION(8) == true)]{
			<div class="manufacture-box-image-box-normal" style="filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/manufacturers/[:label]_logo.png', sizingMethod='scale');"></div>
			<div class="manufacture-box-image-box-gray" style="filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/manufacturers/[:label]_glogo.png', sizingMethod='scale');"></div>
		}
	</a>
</div>