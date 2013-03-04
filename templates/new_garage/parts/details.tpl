<li>
    <div class="big-part-element-container">
        <div class="big-part-element-image-container" style="background-image:url('{{= Config.imageUrl("part",sk.id,sk.name) }}')">
            <div class="big-part-element-image-backgraund"></div>
        </div>
            <div class="big-part-element-title-container">
                <div class="big-part-element-title-type text-color{{? sk.improvement > 0 && sk.unique == false }}-improved{{?}}{{? sk.unique }}-unique{{?}}">{{= sk.part_modifier }}</div>
                <div class="sk-gradient-whiteline-both">&nbsp;</div>
                <div class="big-part-element-title-manufacturer">
                    {{? sk.manufacturer_name != null }}
                        {{= sk.manufacturer_name }}
                    {{?? }}
                        For all
                    {{?}}
                </div>
                {{? sk.manufacturer_name != null }}
                    <div class="big-part-element-title-model">{{= sk.car_model }}</div>
                {{?}}
            </div>
        <div class="big-part-element-data-container">
            <div class="big-part-element-data-box">
                <div class="big-part-element-data-level text-color{{? sk.improvement > 0 && sk.unique == false }}-improved{{?}}{{? sk.unique }}-unique{{?}}">Level: {{= sk.level }}</div>
                <div class="sk-line">&nbsp;</div>
                <div class="big-part-element-data-field-box clearfix">
                    <div class="big-part-element-data-field-label">{{= sk.parameter1_name }}</div>
                    <div class="big-part-element-data-field-bar-box">
                        <div class="big-part-element-data-field-bar-label">{{= sk.parameter1_values.text }} {{? sk.parameter1_unit != null }} {{= sk.parameter1_unit }} {{?}}</div>
                        <div class="big-part-element-data-field-bar-container">
                            <div class="big-part-element-data-field-bar bar-normal" style="width:{{= sk.parameter1_values.bar + '%'}}"></div>
                        </div>
                    </div>
                </div>
                {{? sk.parameter2_name != null }}
                <div class="sk-line">&nbsp;</div>
                <div class="big-part-element-data-field-box clearfix">
                    <div class="big-part-element-data-field-label">{{= sk.parameter2_name }}</div>
                    <div class="big-part-element-data-field-bar-box">
                        <div class="big-part-element-data-field-bar-label">{{= sk.parameter2_values.text }} {{? sk.parameter2_unit != null }} {{= sk.parameter2_unit }} {{?}}</div>
                        <div class="big-part-element-data-field-bar-container">
                            <div class="big-part-element-data-field-bar bar-normal" style="width:{{= sk.parameter2_values.bar +'%'}}"></div>
                        </div>
                    </div>
                </div>
                {{?}}
                {{? sk.parameter3_name != null }}
                <div class="sk-line">&nbsp;</div>
                <div class="big-part-element-data-field-box clearfix">
                    <div class="big-part-element-data-field-label">{{= sk.parameter3_name }}</div>
                    <div class="big-part-element-data-field-bar-box">
                        <div class="big-part-element-data-field-bar-label">{{= sk.parameter3_values.text }} {{? sk.parameter3_unit != null }} {{= sk.parameter3_unit }} {{?}}</div>
                        <div class="big-part-element-data-field-bar-container">
                            <div class="big-part-element-data-field-bar bar-normal" style="width:{{= sk.parameter3_values.bar +'%'}}"></div>
                        </div>
                    </div>
                </div>
                {{?}}
                <div class="sk-line">&nbsp;</div>
                <div class="big-part-element-data-field-box clearfix">
                    <div class="big-part-element-data-field-label">Weight</div>
                    <div class="big-part-element-data-field-bar-box">
                        <div class="big-part-element-data-field-bar-label">{{= sk.weight_values.text }} kg</div>
                        <div class="big-part-element-data-field-bar-container">
                            <div class="big-part-element-data-field-bar bar-normal" style="width:{{= sk.weight_values.bar + '%'}}"></div>
                        </div>
                    </div>
                </div>
                {{? sk.unique == false }}
                    <div class="sk-line">&nbsp;</div>
                    <div class="big-part-element-data-field-box clearfix">
                        <div class="big-part-element-data-field-label">Improved</div>
                        <div class="big-part-element-data-field-bar-box">
                            <div class="big-part-element-data-field-bar-label">{{= Math.floor(sk.improvement/100) }}%</div>
                            <div class="big-part-element-data-field-bar-container">
                                <div class="big-part-element-data-field-bar bar-improved" style="width:{{= Math.floor(sk.improvement/100) + '%'}}"></div>
                            </div>
                        </div>
                    </div>
                {{?}}
                <div class="sk-line">&nbsp;</div>
                <div class="big-part-element-data-field-box clearfix">
                    <div class="big-part-element-data-field-label">Used</div>
                    <div class="big-part-element-data-field-bar-box">
                        <div class="big-part-element-data-field-bar-label">{{= Math.floor(sk.wear/100) }}%</div>
                        <div class="big-part-element-data-field-bar-container">
                            <div class="big-part-element-data-field-bar bar-used-180" style="width:{{= Math.floor(sk.wear/100) + '%'}}"></div>
                        </div>
                    </div>
                </div>
                <div class="sk-line">&nbsp;</div>
                <div class="big-part-element-button-container clearfix">
                    <a href="#Market/sell?part_instance_id={{=sk.part_instance_id}}" class="button icon-text" module="GARAGE_PART_SELL"><span class="icon-part-sell"></span></a>
                    {{? sk.unique == false && Math.floor(sk.improvement/100) <100 }}
                        <a href="#Personnel/task?subject_id={{=sk.part_instance_id}}&task=improve_part" class="button icon-text cmd-improve" module="GARAGE_TASK"><span class="icon-part-improve"></span><div>&nbsp;</div></a>
                    {{?}}
                    {{? sk.wear > 0 }} 
                        <a href="#Personnel/task?subject_id={{=sk.part_instance_id}}&task=repair_part" class="button icon-text cmd-repair" module="GARAGE_TASK"><span class="icon-part-repair"></span><div>&nbsp;</div></a>
                    {{?}}
                </div>
            </div>
        </div>
    </div>
</li>
