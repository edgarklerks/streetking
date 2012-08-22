<div class="report-element-container backgound-darkgray">
	<div class="report-element-container-title">
		[:when (report_descriptor == "part_trashed")]{Part sold to a scrap}
		[:when (report_descriptor == "market_part_fee")]{Part placed to a marketplace}
		[:when (report_descriptor == "shop_part_buy")]{Purchases of new part}
		[:when (report_descriptor == "shop_car_buy")]{Purchases of new car}
		[:when (report_descriptor == "market_part_buy")]{Purchased part from market shop}
		[:when (report_descriptor == "market_car_buy")]{Purchased car from market shop}
		[:when (report_descriptor == "market_car_fee")]{Car placed to a marketplace}
		[:when (report_descriptor == "market_car_sell")]{Your car is bought from the market}
		[:when (report_descriptor == "market_part_sell")]{Your part is bought from the market}
	</div>
	<div class="report-element-container-inner">
		<div class="report-element-image-container [:when (improvement > 0 & unique == false)]{report-element-image-container-improved}[:when (unique)]{report-element-image-container-unique} black-icons-100 [:when (part_type == "engine")]{report-element-[:part_type]-black}[:when (part_type != "engine")]{report-element-image-container-image}" [:when (part_type != "engine")]{style="background-image:url(test_store/[:part_type]/[:part_type]_[:picture].jpg?t=[:eval TIMESTAMP(id)])"}>[:when (part_type != "engine")]{<div class="report-element-image-zoom element-image-zoom">&nbsp;</div>}</div>
		<div class="report-element-data-container">
			<div class="report-element-info-container">
				<div class="report-element-infotext-container">
					<div>Manufacturer:&nbsp;<span>[:when (car_manufacturer_name != null)]{[:car_manufacturer_name]}[:when (part_manufacturer_name != null)]{[:part_manufacturer_name]}[:when (car_manufacturer_name == null & part_manufacturer_name == null)]{For all}</span></div>
					<div>Model:&nbsp;<span>[:when (car_name != null)]{[:car_name]}[:when (part_car_model != null)]{[:part_car_model]}[:when (car_name == null & part_car_model == null)]{For all}</span></div>
					[:when (part_modifier != null)]{<div>Type:&nbsp;<span>[:part_modifier]</span></div>}
					[:when (car_year != null)]{<div>Year:&nbsp;<span>[:car_year]</span></div>}
					<div>Level:&nbsp;<span>[:when (part_level != null)]{[:part_level]}[:when (car_level != null)]{[:car_level]}</span></div>
					[:when (report_descriptor != "market_car_sell" & report_descriptor != "market_part_sell" & report_descriptor != "market_part_fee" & report_descriptor != "market_car_fee")]{
						<div>Cost:&nbsp;<span class="red">SK$ [:amount]</span></div>
					}
					[:when (report_descriptor == "market_car_sell" | report_descriptor == "market_part_sell")]{
						<div>Received:&nbsp;<span class="green">SK$ [:amount]</span></div>
					}
					[:when (report_descriptor == "market_part_fee" | report_descriptor == "market_car_fee")]{
						<div>Fee:&nbsp;<span class="red">SK$ [:eval FEECALCULATION(amount)]</span></div>
					}
				</div>
				<div class="report-element-vertical-line"></div>
				<div class="report-element-infobar-container">
					[:when (car_top_speed != null)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Top speed: <span>[:car_top_speed]</span> km/h</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (car_top_speed/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_acceleration != null)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Acceleration: <span>[:car_acceleration]</span> s</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (car_acceleration/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_braking != null)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Braking: <span>[:car_braking]</span></div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (car_braking/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_handling != null)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Handling: <span>[:car_handling]</span></div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (car_handling/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (parameter1_name != null)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">[:parameter1_name]: <span>+[:parameter1]</span> [:when (parameter1_unit != null)]{[:parameter1_unit]}</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (parameter1/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (parameter2_name != null)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">[:parameter2_name]: <span>+[:parameter2]</span> [:when (parameter2_unit != null)]{[:parameter2_unit]}</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (parameter2/100)*100]%"></div>
							</div>
						</div>
					}
					<div class="report-element-info-data-box">
						<div class="report-element-info-data-name">Weight <span>[:when (weight)]{[:weight]}[:when (car_weight)]{[:car_weight]}</span> kg</div>
						<div class="report-element-progress-bar-box ui-corner-all-1px">
							<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:when (weight)]{[:eval ((weight/100)*100)]}[:when (car_weight)]{[:eval ((car_weight/100)*100)]}%"></div>
						</div>
					</div>
					
					
					
					[:when (report_descriptor != "shop_car_buy" & report_descriptor != "market_car_buy" & report_descriptor != "market_car_fee" & report_descriptor != "market_car_sell")]{
						[:when (part_unique == false)]{
							<div class="report-element-info-data-box">
								<div class="report-element-info-data-name">Improve <span>[:eval floor(part_improvement/1000)]</span> %</div>
								<div class="report-element-progress-bar-box ui-corner-all-1px">
									<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval floor(part_improvement/1000)]%"></div>
								</div>
							</div>
						}
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Used <span>[:eval floor(part_wear/1000)]</span> %</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar report-element-progress-used ui-corner-all-1px" style="width:[:eval floor(part_wear/1000)]%"></div>
							</div>
						</div>
					}
					[:when (report_descriptor == "shop_car_buy" | report_descriptor == "market_car_buy" | report_descriptor == "market_car_fee" | report_descriptor == "market_car_sell")]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Used <span>[:eval floor(car_wear/1000)]</span> %</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar report-element-progress-used ui-corner-all-1px" style="width:[:eval floor(car_wear/1000)]%"></div>
							</div>
						</div>
					}
				</div>
				<div class="clearfix"></div>
			</div>
			<div class="report-element-additional-info-box">
				<div>Time:&nbsp;<span>[:eval TIMESTAMPTODATE(time)]</span></div>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
</div>

<!--
<div class="small-element-container ui-corner-all">
	<div class="small-element-image-container small-element-image-container183 [:when (part_improvement > 0 & part_unique == false)]{small-element-image-container-improved}[:when (part_unique)]{small-element-image-container-unique}">
		<div class="small-element-image-box sk-icons-100x180-white-tr-75 sk-icons-100x180-[:when (part_type != null)]{[:part_type]}[:when (part_type == null)]{body}">&nbsp;</div>
	</div>
	<div class="small-element-info-container small-element-info-container183">
		<div class="small-element-info-box small-element-info-box115">
			<div class="small-element-info-about">
				[:when (report_descriptor == "shop_car_buy" | report_descriptor == "market_car_buy" | report_descriptor == "market_car_fee" | report_descriptor == "market_car_sell")]{
					<div class="small-element-info-data-box">
						<div class="small-element-info-data-name">Used <span>[:eval floor(car_wear/1000)]</span> %</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small progress-bar-small-used ui-corner-all-2px" style="width:[:eval floor(car_wear/1000)]%"></div>
						</div>
					</div>
				}
			</div>
			<div class="small-element-info-data">
				<div class="small-element-info-data-box-container">
					[:when (car_top_speed)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">Top speed: <span>[:car_top_speed]</span> km/h</div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (car_top_speed/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_acceleration)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">Acceleration: <span>[:car_acceleration]</span> s</div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (car_acceleration/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_braking)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">Braking: <span>[:car_braking]</span></div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (car_braking/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_handling)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">Handling: <span>[:car_handling]</span></div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (car_handling/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (part_parameter1_name)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">[:part_parameter1_name]: <span>+[:part_parameter1]</span> [:when (part_parameter1_unit != null)]{[:part_parameter1_unit]}</div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (part_parameter1/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (part_parameter2_name)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">[:part_parameter2_name]: <span>+[:part_parameter2]</span> [:when (part_parameter2_unit != null)]{[:part_parameter2_unit]}</div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (part_parameter2/100)*100]%"></div>
							</div>
						</div>
					}

					<div class="small-element-info-data-box">
						<div class="small-element-info-data-name">Weight <span>[:when (part_weight)]{[:part_weight]}[:when (car_weight)]{[:car_weight]}</span> kg</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:when (part_weight)]{[:eval ((part_weight/100)*100)]}[:when (car_weight)]{[:eval ((car_weight/100)*100)]}%"></div>
						</div>
					</div>
					[:when (report_descriptor != "shop_car_buy" & report_descriptor != "market_car_buy" & report_descriptor != "market_car_fee" & report_descriptor != "market_car_sell")]{
						[:when (part_unique == false)]{
							<div class="small-element-info-data-box">
								<div class="small-element-info-data-name">Improve <span>[:eval floor(part_improvement/1000)]</span> %</div>
								<div class="progress-bar-box-small ui-corner-all-2px">
									<div class="progress-bar-small progress-bar-small-improve ui-corner-all-2px" style="width:[:eval ((part_improvement/100000)*100)]%"></div>
								</div>
							</div>
						}
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">Used <span>[:eval floor(part_wear/1000)]</span> %</div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small progress-bar-small-used ui-corner-all-2px" style="width:[:eval floor(part_wear/1000)]%"></div>
							</div>
						</div>
					}
				</div>
			</div>
			<div class="small-element-info-data"></div>
		</div>
	</div>
	<div class="crearfix"></div>
</div>
-->