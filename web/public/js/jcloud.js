/*!
 * jQCloud Plugin for jQuery
 *
 * Version 0.2.10
 *
 * Copyright 2011, Luca Ongaro
 * Licensed under the MIT license.
 *
 * Date: Mon Jan 16 23:31:12 +0100 2012
*/
(function(a){"use strict",a.fn.jQCloud=function(b,c){var d=this,e=d.attr("id")||Math.floor(Math.random()*1e6).toString(36),f={width:d.width(),height:d.height(),center:{x:d.width()/2,y:d.height()/2},delayedMode:b.length>50,randomClasses:0,nofollow:!1,shape:!1};typeof c=="function"&&(c={callback:c}),c=a.extend(f,c||{}),d.addClass("jqcloud");var g=function(){var f=function(a,b){var c=function(a,b){return Math.abs(2*a.offsetLeft+a.offsetWidth-2*b.offsetLeft-b.offsetWidth)<a.offsetWidth+b.offsetWidth&&Math.abs(2*a.offsetTop+a.offsetHeight-2*b.offsetTop-b.offsetHeight)<a.offsetHeight+b.offsetHeight?!0:!1},d=0;for(d=0;d<b.length;d++)if(c(a,b[d]))return!0;return!1};for(var g=0;g<b.length;g++)b[g].weight=parseFloat(b[g].weight,10);b.sort(function(a,b){return a.weight<b.weight?1:a.weight>b.weight?-1:0});var h=c.shape==="rectangular"?18:2,i=[],j=c.width/c.height,k=function(g,k){var l=e+"_word_"+g,m="#"+l,n=typeof c.randomClasses=="number"&&c.randomClasses>0?" r"+Math.ceil(Math.random()*c.randomClasses):a.isArray(c.randomClasses)&&c.randomClasses.length>0?" "+c.randomClasses[Math.floor(Math.random()*c.randomClasses.length)]:"",o=6.28*Math.random(),p=0,q=0,r=0,s=5,t,u;b[0].weight>b[b.length-1].weight&&(s=Math.round((k.weight-b[b.length-1].weight)/(b[0].weight-b[b.length-1].weight)*9)+1),u=a("<span>").attr("id",l).attr("class","w"+s).addClass(n).addClass(k.customClass||null).attr("title",k.title||k.text||""),k.dataAttributes&&a.each(k.dataAttributes,function(a,b){u.attr("data-"+a,b)}),k.url?(t=a("<a>").attr("href",encodeURI(k.url).replace(/'/g,"%27")).text(k.text),!c.nofollow||t.attr("rel","nofollow")):t=k.text,u.append(t);if(!!k.handlers)for(var v in k.handlers)k.handlers.hasOwnProperty(v)&&typeof k.handlers[v]=="function"&&a(u).bind(v,k.handlers[v]);d.append(u);var w=u.width(),x=u.height(),y=c.center.x-w/2,z=c.center.y-x/2,A=u[0].style;A.position="absolute",A.left=y+"px",A.top=z+"px";while(f(document.getElementById(l),i)){if(c.shape==="rectangular"){q++,q*h>(1+Math.floor(r/2))*h*(r%4%2===0?1:j)&&(q=0,r++);switch(r%4){case 1:y+=h*j+Math.random()*2;break;case 2:z-=h+Math.random()*2;break;case 3:y-=h*j+Math.random()*2;break;case 0:z+=h+Math.random()*2}}else p+=h,o+=(g%2===0?1:-1)*h,y=c.center.x-w/2+p*Math.cos(o)*j,z=c.center.y+p*Math.sin(o)-x/2;A.left=y+"px",A.top=z+"px"}i.push(document.getElementById(l)),typeof k.callback=="function"&&k.callback.call(u)},l=function(a){a=a||0,a<b.length?(k(a,b[a]),setTimeout(function(){l(a+1)},10)):typeof c.callback=="function"&&c.callback.call(this)};c.delayedMode||c.delayed_mode?l():(a.each(b,k),typeof c.callback=="function"&&c.callback.call(this))};return setTimeout(function(){g()},10),this}})(jQuery)