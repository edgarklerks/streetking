<div id="user-name-nick">
    <div>{{=sk.nickname}}</div>
    <div>level {{=sk.level}}</div>
</div>
<div id="user-data-container">
    <div id="user-active-car" class="clearfix">
        <div class="label-icon"><span class="icon-car"></span>{{=sk.active_car.manufacturer_name}} {{=sk.active_car.name}}</div>
    </div>
    <div class="sk-gradient-line-reversed1550">&nbsp;</div>
    <div id="user-data-box" class="clearfix">
        <div class="label-icon"><span class="icon-respect"></span>{{=sk.respect}}/{{=sk.next_level.respect_need}} <samp>({{=sk.next_level.respect_left}})</samp></div>
        <div class="sk-verticalgradient-line margin-left5">&nbsp;</div>
        <div class="label-icon"><span class="icon-heart"></span>{{=sk.energy}}/{{=sk.max_energy}} <samp id="refill_health"></samp></div>
        <div class="sk-verticalgradient-line margin-left5">&nbsp;</div>
        <div class="label-icon"><span class="icon-money"></span>{{=sk.money > 100000 ? '~99999K' : sk.money}}</div>
        <div class="sk-verticalgradient-line margin-left5">&nbsp;</div>
        <div class="label-icon cursor-pointer" module="MARKETPLACE"><span class="icon-diamond"></span>{{=sk.diamonds}}</div>
    </div>
</div>
<div class="user-place">{{=sk.continent_name}}&nbsp;&middot;&nbsp;{{=sk.city_name}}</div>
