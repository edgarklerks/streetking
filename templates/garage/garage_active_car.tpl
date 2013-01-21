<div class="garage-active-car-container" style="background-image:url([:eval IMAGESERVER("[\"user_car\","+id+",\"car\"]")])">
	<div class="garage-active-car-info-container corner-box">
		<div class="garage-active-car-manufacture-box">
			<div class="garage-active-car-manufacture-logo-box normal" style="background-image:url(images/manufacturers/[:eval REPLACESPACE(manufacturer_name)]_logo.png);"></div>
			<div class="garage-active-car-manufacture-name-box">
				<div class="garage-active-car-manufacture-name">[:manufacturer_name]</div>
				<div class="garage-active-car-model-name">[:name]</div>
			</div>
		</div>
		<div class="garage-active-car-data-info-box">
			<div class="garage-active-car-info-data-box">
				<div class="garage-active-car-info-data-name">Top speed <span>[:top_speed_values.text]</span> <b>km/h</b></div>
				<div class="garage-active-car-progress-bar-box ui-corner-all-1px">
					<div class="garage-active-car-progress-bar ui-corner-all-1px" style='width:[:top_speed_values.bar]%'></div>
				</div>
			</div>
			<div class="garage-active-car-info-data-box">
				<div class="garage-active-car-info-data-name">Acceleration <span>[:acceleration_values.text]</span> <b>s</b></div>
				<div class="garage-active-car-progress-bar-box ui-corner-all-1px">
					<div class="garage-active-car-progress-bar ui-corner-all-1px" style='width:[:acceleration_values.bar]%'></div>
				</div>
			</div>
			<div class="garage-active-car-info-data-box">
				<div class="garage-active-car-info-data-name">Braking <span>[:stopping_values.text]</span> <b>m</b></div>
				<div class="garage-active-car-progress-bar-box ui-corner-all-1px">
					<div class="garage-active-car-progress-bar ui-corner-all-1px" style='width:[:stopping_values.bar]%'></div>
				</div>
			</div>
			<div class="garage-active-car-info-data-box">
				<div class="garage-active-car-info-data-name">Handling <span>[:cornering_values.text]</span> <b>g</b></div>
				<div class="garage-active-car-progress-bar-box ui-corner-all-1px">
					<div class="garage-active-car-progress-bar ui-corner-all-1px" style='width:[:cornering_values.bar]%'></div>
				</div>
			</div>
			<div class="garage-active-car-info-data-box">
				<div class="garage-active-car-info-data-name">Weight <span>[:weight_values.text]</span> <b>kg</b></div>
				<div class="garage-active-car-progress-bar-box ui-corner-all-1px">
					<div class="garage-active-car-progress-bar ui-corner-all-1px" style="width:[:weight_values.bar]%"></div>
				</div>
			</div>
			<div class="garage-active-car-info-data-box">
				<div class="garage-active-car-info-data-name">Used <span>[:eval floor(wear/100)]</span> <b>%</b></div>
				<div class="garage-active-car-progress-bar-box ui-corner-all-1px">
					<div class="garage-active-car-progress-bar garage-active-car-progress-bar-used ui-corner-all-1px" style="width:[:eval floor(wear/100)]%"></div>
				</div>
			</div>
			<!--
			<div class="garage-active-car-info-data-box">
				<div class="garage-active-car-info-data-name">Top speed <span>[:eval floor(top_speed/10000)]</span> <b>km/h</b></div>
				<div class="garage-active-car-progress-bar-box ui-corner-all-1px">
					<div class="garage-active-car-progress-bar ui-corner-all-1px" style='width:[:eval PROGRESSBAR("["+top_speed/10000+",80,200]")]%'></div>
				</div>
			</div>
			<div class="garage-active-car-info-data-box">
				<div class="garage-active-car-info-data-name">Acceleration <span>[:eval floor(acceleration/1000)/10]</span> <b>s</b></div>
				<div class="garage-active-car-progress-bar-box ui-corner-all-1px">
					<div class="garage-active-car-progress-bar ui-corner-all-1px" style='width:[:eval PROGRESSBAR("["+acceleration/10000+",-4,10]")]%'></div>
				</div>
			</div>
			<div class="garage-active-car-info-data-box">
				<div class="garage-active-car-info-data-name">Braking <span>[:eval floor(stopping/10000)]</span> <b>m</b></div>
				<div class="garage-active-car-progress-bar-box ui-corner-all-1px">
					<div class="garage-active-car-progress-bar ui-corner-all-1px" style='width:[:eval PROGRESSBAR("["+stopping/10000+",-15,70]")]%'></div>
				</div>
			</div>
			<div class="garage-active-car-info-data-box">
				<div class="garage-active-car-info-data-name">Handling <span>[:eval floor(cornering/1000)/10]</span> <b>g</b></div>
				<div class="garage-active-car-progress-bar-box ui-corner-all-1px">
					<div class="garage-active-car-progress-bar ui-corner-all-1px" style='width:[:eval PROGRESSBAR("["+cornering/10000+",0.3,1]")]%'></div>
				</div>
			</div>
			<div class="garage-active-car-info-data-box">
				<div class="garage-active-car-info-data-name">Used <span>[:eval floor(wear/100)]</span> <b>%</b></div>
				<div class="garage-active-car-progress-bar-box ui-corner-all-1px">
					<div class="garage-active-car-progress-bar garage-active-car-progress-bar-used ui-corner-all-1px" style="width:[:eval floor(wear/100)]%"></div>
				</div>
			</div>
			<div class="garage-active-car-info-data-box">
				<div class="garage-active-car-info-data-name">Weight <span>[:weight]</span> <b>kg</b></div>
				<div class="garage-active-car-progress-bar-box ui-corner-all-1px">
					<div class="garage-active-car-progress-bar ui-corner-all-1px" style="width:[:eval ((weight/100)*100)]%"></div>
				</div>
			</div>
			-->
		</div>
		<div class="garage-active-car-buttons-box">
			<div class="garage-active-car-active-button-container">&nbsp;</div>
			<div class="garage-active-car-action-button-container button-box-wider">&nbsp;</div>
			<div class="garage-active-car-info-button-container">
				<a href="#Garage/car?car_instance_id=[:id]&car_id=[:car_id]" class="button width-47p" module="GARAGE_CAR_SETUP">set up</a>
				<a href="#Garage/car?car_instance_id=[:id]" class="button float-right width-47p" module="GARAGE_CAR_INFO">info</a>
			</div>
		</div>
		<div class="dialog-corner dialog-corner-tl dialog-corner-h"></div>
		<div class="dialog-corner dialog-corner-tl dialog-corner-v"></div>
		<div class="dialog-corner dialog-corner-tr dialog-corner-h"></div>
		<div class="dialog-corner dialog-corner-tr dialog-corner-v"></div>
		<div class="dialog-corner dialog-corner-bl dialog-corner-h"></div>
		<div class="dialog-corner dialog-corner-bl dialog-corner-v"></div>
		<div class="dialog-corner dialog-corner-br dialog-corner-h"></div>
		<div class="dialog-corner dialog-corner-br dialog-corner-v"></div>
	</div>
</div>