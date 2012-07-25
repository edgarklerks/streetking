<div class="big-element-container [:when (improvement > 0 & unique == false)]{big-element-container-improved}[:when (unique)]{big-element-container-unique} ui-corner-all">
	<div class="big-element-image-container big-element-image-container178 [:when (improvement > 0 & unique == false)]{big-element-image-container-improved}[:when (unique)]{big-element-image-container-unique} ui-corner-all">
		<img src="test_store/car_[:car_instance_id].jpg?t=[:eval TIMESTAMP(id)]" alt="" border="0" width="360" height="195" class="big-element-car-image" />
		<div class="big-element-image-overlay ui-corner-all">&nbsp;</div>
	</div>
	<div class="big-element-info-container big-element-info-container178">
		<div class="big-element-info-box">
			<div class="big-element-info-about">
				<div>Manufacturer:&nbsp;<b>[:manufacturer_name]</b></div>
				<div>Model:&nbsp;<b>[:name]</b></div>
				<div>Year:&nbsp;<b>[:year]</b></div>
				<div>Level:&nbsp;<b>[:level]</b></div>
				<div>Price:&nbsp;<b class="red">SK$ [:price]</b></div>
				<div class="big-element-info-additional-box">
					<div class="big-element-info-additional-left-box"></div>
					<div class="big-element-info-additional-right-box">
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">Used <span>[:eval floor(wear/1000)]</span> %</div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small progress-bar-info-used185 ui-corner-all-2px" style="width:[:eval floor(wear/1000)]%"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="big-element-info-data">
				<div class="big-element-info-data-box-container">
					<div class="big-element-info-data-box">
						<div class="big-element-info-data-name">Top speed <span>[:top_speed]</span> km/h</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((top_speed/100)*100)]%"></div>
						</div>
					</div>
					<div class="big-element-info-data-box">
						<div class="big-element-info-data-name">Acceleration <span>[:acceleration]</span> s</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((acceleration/100)*100)]%"></div>
						</div>
					</div>
					<div class="big-element-info-data-box">
						<div class="big-element-info-data-name">Braking <span>[:braking]</span></div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((braking/100)*100)]%"></div>
						</div>
					</div>
					<div class="big-element-info-data-box">
						<div class="big-element-info-data-name">Handling <span>[:handling]</span></div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((handling/100)*100)]%"></div>
						</div>
					</div>
					<div class="big-element-info-data-box">
						<div class="big-element-info-data-name">Weight <span>[:weight]</span> kg</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((weight/100)*100)]%"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="big-element-button-box button-box-wider">
			[:when (requestParams.me != 1)]{<a href="#Market/buyCar?car_instance_id=[:car_instance_id]" class="button car-button" module="MARKETPLACE_USEDCAR_BUY">buy</a>}
			[:when (requestParams.me == 1)]{<a href="#Market/returnCar?car_instance_id=[:car_instance_id]" class="button part-button" module="MARKETPLACE_USEDCAR_RETURN">return</a>}
			<a href="#Market/cars/?car_instance_id=[:car_instance_id]&me=[:requestParams.me]" class="button car-button" module="MARKETPLACE_USEDCAR_INFO">info</a>
		</div>
	</div>
	<div class="crearfix"></div>
</div>