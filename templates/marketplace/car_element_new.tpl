<div class="car-element-container backgound-darkgray">
	<!--<div class="car-element-image-container car-element-image-container-image" style="background-image:url(test_store/stock_car/[:eval LOWERCASE(manufacturer_name)]_[:eval LOWERCASE(name)].jpg?t=[:eval TIMESTAMP(id)])">&nbsp;</div>-->
	<div class="car-element-image-container car-element-image-container-image" style='background-image:url([:eval IMAGESERVER("[\"car\","+car_id+",\"car\"]")])'>&nbsp;</div>
	<div class="car-element-data-container">
		<div class="car-element-info-container">
			<div class="car-element-infotext-container">
				<div>Manufacturer:&nbsp;<span>[:manufacturer_name]</span></div>
				<div>Model:&nbsp;<span>[:name]</span></div>
				<div>Year:&nbsp;<span>[:year]</span></div>
				<div>Level:&nbsp;<span>[:level]</span></div>
				<div>Price:&nbsp;<span>SK$ [:total_price]</span></div>
			</div>
			<div class="car-element-vertical-line"></div>
			<div class="car-element-infobar-container">
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Top speed <span>[:eval floor(top_speed/10000)]</span> <b>km/h</b></div>
					<div class="car-element-progress-bar-box ui-corner-all-1px">
						<div class="car-element-progress-bar ui-corner-all-1px" style='width:[:eval PROGRESSBAR("["+top_speed/10000+",80,200]")]%'></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Acceleration <span>[:eval floor(acceleration/1000)/10]</span> <b>s</b></div>
					<div class="car-element-progress-bar-box ui-corner-all-1px">
						<div class="car-element-progress-bar ui-corner-all-1px" style='width:[:eval PROGRESSBAR("["+acceleration/10000+",-4,10]")]%'></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Braking <span>[:eval floor(stopping/10000)]</span> <b>m</b></div>
					<div class="car-element-progress-bar-box ui-corner-all-1px">
						<div class="car-element-progress-bar ui-corner-all-1px" style='width:[:eval PROGRESSBAR("["+stopping/10000+",-15,70]")]%'></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Handling <span>[:eval floor(cornering/1000)/10]</span> <b>g</b></div>
					<div class="car-element-progress-bar-box ui-corner-all-1px">
						<div class="car-element-progress-bar ui-corner-all-1px" style='width:[:eval PROGRESSBAR("["+cornering/10000+",0.3,1]")]%'></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Weight <span>[:weight]</span> kg</div>
					<!--
					<div class="car-element-progress-bar-box ui-corner-all-1px">
						<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((weight/1)*1)]%"></div>
					</div>
					-->
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>
	<div class="clearfix"></div>
	<div class="car-element-buttons-container">
		[:when (requestParams.action == "Market/prototype/")]{<a href="#Car/buy?id=[:id]" class="button car-button" module="MARKETPLACE_NEWCAR_BUY">buy</a>}
	</div>
	<div class="clearfix"></div>
</div>