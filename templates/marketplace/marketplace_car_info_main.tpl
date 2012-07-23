<div id="info-car-box" title="Car info">
	<div class="info-car-box" alt="" title="">
		<div class="info-car-image" style="background-image:url(test_store/car_[:0.car_instance_id].jpg?t=[:eval TIMESTAMP(0.car_instance_id)])">
			<div class="car-info-box-container ui-corner-all">
				<div class="car-info-box-info-container car-info-box-info-container178">
					<div class="car-info-box-info-box">
						<div class="car-info-box-info-about">
							<div class="car-info-about-left-box">
								<div>Manufacturer:&nbsp;<b>[:0.manufacturer_name]</b></div>
								<div>Model:&nbsp;<b>[:0.name]</b></div>
							</div>
							<div class="car-info-about-right-box">
								<div>Year:&nbsp;<b>[:0.year]</b></div>
								<div>Level:&nbsp;<b>[:0.level]</b></div>
							</div>
						</div>
						<div class="car-info-box-info-data">
							<div class="car-info-additional-left-box">
								<div class="car-info-box-info-data-box">
									<div class="car-info-box-info-data-name">Top speed <span>[:0.top_speed]</span> km/h</div>
									<div class="progress-bar-box-info ui-corner-all-2px">
										<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval ((0.top_speed/100)*100)]%"></div>
									</div>
								</div>
								<div class="car-info-box-info-data-box">
									<div class="car-info-box-info-data-name">Acceleration <span>[:0.acceleration]</span> s</div>
									<div class="progress-bar-box-info ui-corner-all-2px">
										<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval ((0.acceleration/100)*100)]%"></div>
									</div>
								</div>
								<div class="car-info-box-info-data-box">
									<div class="car-info-box-info-data-name">Braking <span>[:0.braking]</span></div>
									<div class="progress-bar-box-info ui-corner-all-2px">
										<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval ((0.braking/100)*100)]%"></div>
									</div>
								</div>
							</div>
							<div class="car-info-additional-right-box">
								<div class="car-info-box-info-data-box">
									<div class="car-info-box-info-data-name">Handling <span>[:0.handling]</span></div>
									<div class="progress-bar-box-info ui-corner-all-2px">
										<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval ((0.handling/100)*100)]%"></div>
									</div>
								</div>
								<div class="car-info-box-info-data-box">
									<div class="car-info-box-info-data-name">Weight <span>[:0.weight]</span> kg</div>
									<div class="progress-bar-box-info ui-corner-all-2px">
										<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval ((0.weight/100)*100)]%"></div>
									</div>
								</div>
								<div class="small-element-info-data-box">
									<div class="small-element-info-data-name">Used <span>[:0.wear]</span> %</div>
									<div class="progress-bar-box-info ui-corner-all-2px">
										<div class="progress-bar-info progress-bar-info-used270 ui-corner-all-2px" style="width:[:eval floor(0.wear/1000)]%"></div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="crearfix"></div>
			</div>
		</div>
		<div id="info-car-info-box" class="info-car-info-box"></div>
		<div class="clearfix"></div>
	</div>
</div>