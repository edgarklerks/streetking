{{? sk.length != 0 }}
    <div class="showroom-element-container" style="background-image: url('{{=Config.imageUrl("user_car",sk[0].id,sk[0].car_id) }}')">
        <div class="showroom-element-gradient"></div>
        <div class="showroom-element-data-container">
            <div class="showroom-element-info-button-container clearfix">
                <a href="#Garage/car?car_instance_id={{=sk[0].id}}" class="button icon-text" module="GARAGE_CAR_INFO"><span class="icon-car-info"></span></a>
            </div>
            <div class="sk-line">&nbsp;</div>
            <div class="showroom-element-data-field-box clearfix">
                <div class="showroom-element-data-field-label">Top speed</div>
                <div class="showroom-element-data-field-bar-box">
                    <div class="showroom-element-data-field-bar-label">{{= sk[0].top_speed_values.text }} km/h</div>
                    <div class="showroom-element-data-field-bar-container">
                        <div class="showroom-element-data-field-bar bar-normal" style="width:{{= sk[0].top_speed_values.bar + '%'}}"></div>
                    </div>
                </div>
            </div>
            <div class="sk-line">&nbsp;</div>
            <div class="showroom-element-data-field-box clearfix">
                <div class="showroom-element-data-field-label">Acceleration</div>
                <div class="showroom-element-data-field-bar-box">
                    <div class="showroom-element-data-field-bar-label">{{= sk[0].acceleration_values.text }}</div>
                    <div class="showroom-element-data-field-bar-container">
                        <div class="showroom-element-data-field-bar bar-normal" style="width:{{= sk[0].acceleration_values.bar + '%'}}"></div>
                    </div>
                </div>
            </div>
            <div class="sk-line">&nbsp;</div>
            <div class="showroom-element-data-field-box clearfix">
                <div class="showroom-element-data-field-label">Braking</div>
                <div class="showroom-element-data-field-bar-box">
                    <div class="showroom-element-data-field-bar-label">{{= sk[0].stopping_values.text }}</div>
                    <div class="showroom-element-data-field-bar-container">
                        <div class="showroom-element-data-field-bar bar-normal" style="width:{{= sk[0].stopping_values.bar + '%'}}"></div>
                    </div>
                </div>
            </div>
            <div class="sk-line">&nbsp;</div>
            <div class="showroom-element-data-field-box clearfix">
                <div class="showroom-element-data-field-label">Handling</div>
                <div class="showroom-element-data-field-bar-box">
                    <div class="showroom-element-data-field-bar-label">{{= sk[0].cornering_values.text }}</div>
                    <div class="showroom-element-data-field-bar-container">
                        <div class="showroom-element-data-field-bar bar-normal" style="width:{{= sk[0].cornering_values.bar + '%'}}"></div>
                    </div>
                </div>
            </div>
            <div class="sk-line">&nbsp;</div>
            <div class="showroom-element-data-field-box clearfix">
                <div class="showroom-element-data-field-label">Weight</div>
                <div class="showroom-element-data-field-bar-box">
                    <div class="showroom-element-data-field-bar-label">{{= sk[0].weight_values.text }} kg</div>
                    <div class="showroom-element-data-field-bar-container">
                        <div class="showroom-element-data-field-bar bar-normal" style="width:{{= sk[0].weight_values.bar + '%'}}"></div>
                    </div>
                </div>
            </div>
            <div class="sk-line">&nbsp;</div>
            <div class="showroom-element-data-field-box clearfix">
                <div class="showroom-element-data-field-label">Used</div>
                <div class="showroom-element-data-field-bar-box">
                    <div class="showroom-element-data-field-bar-label">{{= Math.floor(sk[0].wear/100) }}%</div>
                    <div class="showroom-element-data-field-bar-container">
                        <div class="showroom-element-data-field-bar bar-normal" style="width:{{= Math.floor(sk[0].wear/100) + '%'}}"></div>
                    </div>
                </div>
            </div>
            <div class="sk-line">&nbsp;</div>
            <div class="showroom-element-action-button-container clearfix">
                {{? sk[0].active == false }}
                    <a href="#Garage/car?car_instance_id={{=sk[0].id}}" class="button car-button" module="GARAGE_CAR_SELL"><span class="icon-car-sell"></span><div>&nbsp;</div></a>
                {{?}}
                {{? sk[0].wear > 0 }}
                    <a href="#Personnel/task?subject_id={{=sk[0].id}}&task=repair_car" class="button icon-text cmd-repair" module="GARAGE_TASK"><span class="icon-car-repair"></span><div>&nbsp;</div></a>
                {{?}}
                <a href="#Garage/car?car_instance_id={{=sk[0].id}}&car_id={{=sk[0].car_id}}" class="button icon-text" module="GARAGE_CAR_SETUP"><span class="icon-car-setup"></span><div>&nbsp;</div></a>
                {{? sk[0].active == false }}
                    {{? sk[0].ready == true }}
                        <a href="#Car/activate?id={{=sk[0].id}}" class="button icon-text" module="GARAGE_CAR_SET_ACTIVE"><span class="icon-car-set-active"></span><div>&nbsp;</div></a>
                    {{??}}
                        <a href="#Garage/carReady?id={{=sk[0].id}}" class="button icon-text" module="GARAGE_CAR_SET_ACTIVE_FAIL"><span class="icon-car-set-active"></span><div>&nbsp;</div></a>
                    {{?}}
                {{?}}
            </div>
        </div>
    </div>
{{?}}