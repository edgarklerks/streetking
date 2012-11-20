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
		[:when (report_descriptor == "car_trashed")]{Car sold to a scrap}
	</div>
	<div class="report-element-container-inner">
<!--		<div class="report-element-image-container [:when (improvement > 0 & unique == false)]{report-element-image-container-improved}[:when (unique)]{report-element-image-container-unique} black-icons-100 [:when (part_type == "engine")]{report-element-[:part_type]-black}[:when (part_type != "engine")]{report-element-image-container-image}" [:when (part_type != "engine")]{style="background-image:url(test_store/[:part_type]/[:part_type]_[:picture].jpg?t=[:eval TIMESTAMP(id)])"}>[:when (part_type != "engine")]{<div class="report-element-image-zoom element-image-zoom">&nbsp;</div>}</div> -->
<div class="report-element-image-container [:when (improvement > 0 & unique == false)]{report-element-image-container-improved}[:when (unique)]{report-element-image-container-unique} report-element-image-container-image" style='background-image:url([:when (part_type != null)]{ [:eval IMAGESERVER("[\"part\","+part_id+",\"" + part_type + "\"]")] } [:when (part_type == null)]{ [:eval IMAGESERVER("[\"user_car\","+car_instance_id+",\"car\"]")] })'>
<div class="report-element-image-zoom element-image-zoom [:when (report_descriptor == "shop_car_buy" | report_descriptor == "market_car_buy" | report_descriptor == "market_car_fee" | report_descriptor == "market_car_sell" | report_descriptor == "car_trashed")]{car-element-image-zoom}">&nbsp;</div>
</div>
		<div class="report-element-data-container">
			<div class="report-element-info-container">
				<div class="report-element-infotext-container">
					<div>Manufacturer:&nbsp;<span>[:when (car_manufacturer_name != null)]{[:car_manufacturer_name]}[:when (part_manufacturer_name != null)]{[:part_manufacturer_name]}[:when (car_manufacturer_name == null & part_manufacturer_name == null)]{For all}</span></div>
					<div>Model:&nbsp;<span>[:when (car_name != null)]{[:car_name]}[:when (part_car_model != null)]{[:part_car_model]}[:when (car_name == null & part_car_model == null)]{For all}</span></div>
					[:when (part_modifier != null)]{<div>Type:&nbsp;<span>[:part_modifier]</span></div>}
					[:when (car_year != null)]{<div>Year:&nbsp;<span>[:car_year]</span></div>}
					<div>Level:&nbsp;<span>[:when (part_level != null)]{[:part_level]}[:when (car_level != null)]{[:car_level]}</span></div>
					[:when (report_descriptor != "market_car_sell" & report_descriptor != "market_part_sell" & report_descriptor != "market_part_fee" & report_descriptor != "market_car_fee" & report_descriptor != "car_trashed" & report_descriptor != "part_trashed")]{
						<div>Cost:&nbsp;<span class="red">SK$ [:amount]</span></div>
					}
					[:when (report_descriptor == "market_car_sell" | report_descriptor == "market_part_sell" | report_descriptor == "car_trashed" | report_descriptor == "part_trashed")]{
						<div>Received:&nbsp;<span class="green">SK$ [:amount]</span></div>
					}
					[:when (report_descriptor == "market_part_fee" | report_descriptor == "market_car_fee")]{
						<div>Fee:&nbsp;<span class="red">SK$ [:eval FEECALCULATION(amount)]</span></div>
					}
				</div>
				<div class="report-element-vertical-line"></div>
				<div class="report-element-infobar-container">
					[:when (report_descriptor == "shop_car_buy" | report_descriptor == "market_car_buy" | report_descriptor == "market_car_fee" | report_descriptor == "market_car_sell" | report_descriptor == "car_trashed")]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Top speed: <span>[:car_top_speed_values.text]</span> km/h</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:car_top_speed_values.bar]%"></div>
							</div>
						</div>
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Acceleration: <span>[:car_acceleration_values.text]</span> s</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:car_acceleration_values.bar]%"></div>
							</div>
						</div>
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Braking: <span>[:car_stopping_values.text]</span> m</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:car_stopping_values.bar]%"></div>
							</div>
						</div>
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Handling: <span>[:car_cornering_values.text]</span> g</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:car_cornering_values.bar]%"></div>
							</div>
						</div>
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Weight: <span>[:car_weight_values.text]</span> kg</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:car_weight_values.bar]%"></div>
							</div>
						</div>
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Used <span>[:eval floor(car_wear/100)]</span> %</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar report-element-progress-used ui-corner-all-1px" style="width:[:eval floor(car_wear/100)]%"></div>
							</div>
						</div>
					}
					[:when (report_descriptor != "shop_car_buy" & report_descriptor != "market_car_buy" & report_descriptor != "market_car_fee" & report_descriptor != "market_car_sell" & report_descriptor != "car_trashed")]{
						[:when (part_parameter1_name != null)]{
							<div class="report-element-info-data-box">
								<div class="report-element-info-data-name">[:part_parameter1_name]: <span>[:part_parameter1_values.text]</span> [:when (part_parameter1_unit != null)]{[:part_parameter1_unit]}</div>
								<div class="report-element-progress-bar-box ui-corner-all-1px">
									<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:part_parameter1_values.bar]%"></div>
								</div>
							</div>
						}
						[:when (part_parameter2_name != null)]{
							<div class="report-element-info-data-box">
								<div class="report-element-info-data-name">[:part_parameter2_name]: <span>[:part_parameter2_values.text]</span> [:when (part_parameter2_unit != null)]{[:part_parameter2_unit]}</div>
								<div class="report-element-progress-bar-box ui-corner-all-1px">
									<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:part_parameter2_values.bar]%"></div>
								</div>
							</div>
						}
						[:when (part_parameter3_name != null)]{
							<div class="report-element-info-data-box">
								<div class="report-element-info-data-name">[:part_parameter3_name]: <span>+[:part_parameter3_values.text]</span> [:when (part_parameter3_unit != null)]{[:part_parameter3_unit]}</div>
								<div class="report-element-progress-bar-box ui-corner-all-1px">
									<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:part_parameter3_values.bar]%"></div>
								</div>
							</div>
						}
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Weight <span>[:part_weight]</span> kg</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:part_weight]%"></div>
							</div>
						</div>
						[:when (part_unique == false)]{
							<div class="report-element-info-data-box">
								<div class="report-element-info-data-name">Improve <span>[:eval floor(part_improvement/100)]</span> %</div>
								<div class="report-element-progress-bar-box ui-corner-all-1px">
									<div class="report-element-progress-bar report-element-progress-improve ui-corner-all-1px" style="width:[:eval floor(part_improvement/100)]%"></div>
								</div>
							</div>
						}
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Used <span>[:eval floor(part_wear/100)]</span> %</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar report-element-progress-used ui-corner-all-1px" style="width:[:eval floor(part_wear/100)]%"></div>
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