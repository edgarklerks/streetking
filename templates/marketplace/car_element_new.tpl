<div class="car-element-container backgound-darkgray">
	<!--<div class="car-element-image-container car-element-image-container-image" style="background-image:url(test_store/stock_car/[:eval LOWERCASE(0.manufacturer_name)]_[:eval LOWERCASE(0.name)].jpg?t=[:eval TIMESTAMP(id)])">&nbsp;</div>-->
	<div class="car-element-image-container car-element-image-container-image" style='background-image:url([:eval IMAGESERVER("[\"car\","+0.id+",\"car\"]")])'>&nbsp;</div>
	<div class="car-element-data-container">
		<div class="car-element-info-container">
			<div class="car-element-infotext-container">
				<div>Manufacturer:&nbsp;<span>[:0.manufacturer_name]</span></div>
				<div>Model:&nbsp;<span>[:0.name]</span></div>
				<div>Year:&nbsp;<span>[:0.year]</span></div>
				<div>Level:&nbsp;<span>[:0.level]</span></div>
				<div>Price:&nbsp;<span>SK$ [:0.price]</span></div>
			</div>
			<div class="car-element-vertical-line"></div>
			<div class="car-element-infobar-container">
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Top speed <span>[:0.top_speed]</span> km/h</div>
					<div class="car-element-progress-bar-box ui-corner-all-1px">
						<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.top_speed/100)*100)]%"></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Acceleration <span>[:0.acceleration]</span> s</div>
					<div class="car-element-progress-bar-box ui-corner-all-1px">
						<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.acceleration/100)*100)]%"></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Braking <span>[:0.braking]</span></div>
					<div class="car-element-progress-bar-box ui-corner-all-1px">
						<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.braking/100)*100)]%"></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Handling <span>[:0.handling]</span></div>
					<div class="car-element-progress-bar-box ui-corner-all-1px">
						<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.handling/100)*100)]%"></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Weight <span>[:0.weight]</span> kg</div>
					<div class="car-element-progress-bar-box ui-corner-all-1px">
						<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.weight/100)*100)]%"></div>
					</div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>
	<div class="clearfix"></div>
	<div class="car-element-buttons-container">
		[:when (requestParams.action == "Market/model/")]{<a href="#Car/buy?id=[:0.id]" class="button car-button" module="MARKETPLACE_NEWCAR_BUY">buy</a>}
	</div>
	<div class="clearfix"></div>
</div>