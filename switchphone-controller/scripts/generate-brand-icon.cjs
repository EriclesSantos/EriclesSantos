// Vector adaptation of the existing Nordhub circuit-hammer mark for the controller icon.
// Run with Node.js; set NORDHUB_PREVIEW_DIR and install sharp only to render optional PNGs.
const fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'..'),res=path.join(root,'android-app/app/src/main/res');
const purple='#A88CFF',cyan='#00C6FF',background='#090A12';
const body='M33 34 H75 C82 34 85 40 87 47 L92 71 C94 81 86 86 79 79 L68 68 H40 L29 79 C22 86 14 81 16 71 L21 47 C23 40 26 34 33 34 Z';
const hammer=[
 'M249 182 L222 198 V284 L249 300 Z M486 182 L513 198 V284 L486 300 Z',
 'M260 198 C287 198 307 188 316 166 H418 C428 188 449 198 474 198 M260 220 C293 220 315 208 330 190 H404 C423 209 443 220 474 220',
 'M268 220 V263 C295 262 311 266 326 280 M268 240 H304 M432 240 H466 M466 220 V263 C441 262 422 266 409 280',
 'M260 283 C291 281 316 290 329 320 H405 C419 290 445 281 474 283',
 'M322 330 L313 394 C311 410 301 426 279 432 H234 L218 505 C280 514 327 537 367 574 C406 537 454 514 516 505 L500 432 H455 C433 426 424 410 421 394 L412 330',
 'M344 348 L333 425 M390 348 L401 425 M344 369 L367 399 L390 369 M367 320 V355 M367 422 V458',
 'M279 432 L367 464 L455 432 M252 456 H279 L329 476 M482 456 H455 L417 476 M247 480 L250 465 M247 480 C297 490 334 515 367 544 C401 515 438 490 487 480 L484 465 M350 505 L377 479 L396 497 L367 522'
];
const rune='M367 202 L402 239 L367 277 L392 295 L384 303 L367 286 L348 303 L337 295 L357 275 L332 239 Z M367 219 L386 239 L367 259 L348 239 Z';
const circuits=[[330,190],[404,190],[310,240],[424,240],[344,342],[390,342],[333,425],[401,425],[367,362],[367,422],[329,491],[417,491]];
const markSvg=`<g transform="translate(28.3 26.6) scale(.07)" fill="none" stroke="#E3D5FF" stroke-width="10" stroke-linejoin="round" stroke-linecap="round">${hammer.map(d=>`<path d="${d}"/>`).join('')}${circuits.map(([x,y])=>`<circle cx="${x}" cy="${y}" r="5.5" fill="${background}" stroke-width="8"/>`).join('')}<path d="${rune}" stroke="${cyan}" stroke-width="8"/></g>`;
const controlsSvg=`<path d="M29 47 H33 V52 H38 V56 H33 V61 H29 V56 H24 V52 H29 Z" fill="${purple}"/>${[[77,46],[84,53],[77,60],[70,53]].map(([x,y],i)=>`<circle cx="${x}" cy="${y}" r="2.3" fill="${i%2?purple:cyan}"/>`).join('')}`;
const content=`<path d="${body}" fill="#171324" stroke="url(#brand)" stroke-width="2.5"/>${controlsSvg}${markSvg}`;
const defs=`<defs><linearGradient id="brand" x1="0" x2="1"><stop stop-color="${purple}"/><stop offset="1" stop-color="${cyan}"/></linearGradient></defs>`;
const svg=`<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 108 108">${defs}<rect width="108" height="108" rx="23" fill="${background}"/>${content}</svg>`;
const vpath=(d,color,width=0)=>`<path android:pathData="${d}" android:fillColor="${width?'@android:color/transparent':color}"${width?` android:strokeColor="${color}" android:strokeWidth="${width}" android:strokeLineJoin="round" android:strokeLineCap="round"`:''}/>`;
const circles=circuits.map(([x,y])=>vpath(`M${x-5.5},${y} a5.5,5.5 0,1 0,11 0 a5.5,5.5 0,1 0,-11 0`,'#E3D5FF',8)).join('');
const mark=`<group android:translateX="28.3" android:translateY="26.6" android:scaleX="0.07" android:scaleY="0.07">${hammer.map(d=>vpath(d,'#E3D5FF',10)).join('')}${circles}${vpath(rune,cyan,8)}</group>`;
const bodyVector=`<path android:pathData="${body}" android:fillColor="#171324" android:strokeWidth="2.5"><aapt:attr name="android:strokeColor"><gradient android:startX="16" android:startY="54" android:endX="92" android:endY="54" android:startColor="${purple}" android:endColor="${cyan}" android:type="linear"/></aapt:attr></path>`;
const controlsVector=vpath('M29 47 H33 V52 H38 V56 H33 V61 H29 V56 H24 V52 H29 Z',purple)+[[77,46],[84,53],[77,60],[70,53]].map(([x,y],i)=>vpath(`M${x-2.3},${y} a2.3,2.3 0,1 0,4.6 0 a2.3,2.3 0,1 0,-4.6 0`,i%2?purple:cyan)).join('');
const vector=(inner)=>`<vector xmlns:android="http://schemas.android.com/apk/res/android" xmlns:aapt="http://schemas.android.com/aapt" android:width="108dp" android:height="108dp" android:viewportWidth="108" android:viewportHeight="108">${inner}</vector>\n`;
const full=vector(vpath('M0 0 H108 V108 H0 Z',background)+bodyVector+controlsVector+mark);
const foreground=vector(`<group android:pivotX="54" android:pivotY="54" android:scaleX="0.82" android:scaleY="0.82">${bodyVector}${controlsVector}${mark}</group>`);
for(const [relative,data] of Object.entries({'drawable/ic_controller.xml':full,'drawable/ic_controller_foreground.xml':foreground,'mipmap-anydpi/ic_launcher.xml':full,'mipmap-anydpi-v26/ic_launcher.xml':'<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android"><background android:drawable="@color/nordhub_background"/><foreground android:drawable="@drawable/ic_controller_foreground"/></adaptive-icon>\n','values/colors.xml':`<resources><color name="nordhub_background">${background}</color><color name="nordhub_purple">${purple}</color><color name="nordhub_cyan">${cyan}</color></resources>\n`})){
 const file=path.join(res,relative);fs.mkdirSync(path.dirname(file),{recursive:true});fs.writeFileSync(file,data);
}
const asset=path.join(root,'docs/assets/nordhub-procontroller-icon.svg');fs.mkdirSync(path.dirname(asset),{recursive:true});fs.writeFileSync(asset,svg);
if(process.env.NORDHUB_PREVIEW_DIR){
 const sharp=require('sharp'),out=process.env.NORDHUB_PREVIEW_DIR;fs.mkdirSync(out,{recursive:true});
 sharp(Buffer.from(svg)).png().toFile(path.join(out,'nordhub-procontroller-icon.png')).then(()=>console.log('Brand icon vector and PNG generated')).catch(e=>{console.error(e);process.exitCode=1;});
}else console.log('Brand icon vectors generated');
