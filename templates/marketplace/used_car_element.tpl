<div class="car-element-container backgound-darkgray">
	<!--<div class="car-element-image-container car-element-image-container-image" style="background-image:url(test_store/car_[:car_instance_id].jpg?t=[:eval TIMESTAMP(id)])">&nbsp;</div>-->
	<div class="car-element-image-container car-element-image-container-image" style='background-image:url([:eval IMAGESERVER("[\"user_car\","+car_instance_id+",\"car\"]")])'>&nbsp;</div>
	<div class="car-element-data-container">
		<div class="car-element-info-container">
			<div class="car-element-infotext-container">
				<div>Manufacturer:&nbsp;<span>[:manufacturer_name]</span></div>
				<div>Model:&nbsp;<span>[:model]</span></div>
				<div>Year:&nbsp;<span>[:year]</span></div>
				<div>Level:&nbsp;<span>[:level]</span></div>
				<div>Price:&nbsp;<span>SK$ [:price]</span></div>
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
					<div class="car-element-info-data-box-name">Used <span>[:eval floor(wear/100)]</span> %</div>
					<div class="car-element-progress-bar-box ui-corner-all-1px">
						<div class="car-element-progress-bar car-element-progress-used ui-corner-all-1px" style="width:[:eval floor(wear/100)]%"></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Weight <span>[:weight]</span> kg</div>
					<!--
					<div class="car-element-progress-bar-box ui-corner-all-1px">
						<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((weight/100)*100)]%"></div>
					</div>
					-->
				</div>
				<div class="part-element-info-data-box-absolute">
					<a href="#Market/cars/?car_instance_id=[:car_instance_id]&me=[:requestParams.me]" class="button car-info-button" module="MARKETPLACE_USEDCAR_INFO">info</a>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>
	<div class="clearfix"></div>
	<div class="car-element-buttons-container">
		[:when (requestParams.me != 1)]{<a href="#Market/buyCar?car_instance_id=[:car_instance_id]" class="button car-button" module="MARKETPLACE_USEDCAR_BUY">buy</a>}
		[:when (requestParams.me == 1)]{<a href="#Market/returnCar?car_instance_id=[:car_instance_id]" class="button part-button" module="MARKETPLACE_USEDCAR_RETURN">return</a>}
	</div>
	<div class="clearfix"></div>
</div>