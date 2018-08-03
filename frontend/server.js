const Koa = require('koa');
const logger = require('koa-logger');
const router = require('koa-router')();
const request = require('request-promise-native');
const os = require('os');
const app = module.exports = new Koa();

const PORT = process.env.PORT || 3000;
const VERSION = process.env.VERSION || 'v1';
const BACKEND_URL_FOO = process.env.BACKEND_URL_FOO || "";
const BACKEND_URL_BAR = process.env.BACKEND_URL_BAR || "";
// middleware
app.use(logger());

// route definitions
router.get('/',  async (ctx) => { 
  
    const beginfoo = Date.now();
    const headers = "";  //forwardTraceHeaders(ctx.req);

    let foostatus;
    try {
        foostatus = await request({ url: BACKEND_URL_FOO, headers: headers });
    } catch (error) {
        foostatus = error;
    }

    const timeSpentfoo = (Date.now() - beginfoo) / 1000 + "secs";

    const beginbar = Date.now();

    let barstatus;
    try {
        barstatus = await request({ url: BACKEND_URL_BAR, headers: headers });
    } catch (error) {
        barstatus = error;
    }

    const timeSpentbar = (Date.now() - beginbar) / 1000 + "secs";

    ctx.body = `frontend:${VERSION} (${os.hostname()})\n${timeSpentfoo} - ${BACKEND_URL_FOO} -> ${foostatus}\n${timeSpentbar} - ${BACKEND_URL_BAR} -> ${barstatus}`;
 //   res.end(`${service_name} - ${timeSpent}\n${upstream_uri} -> ${up}`)
}).get("/readiness", (ctx) => {
    ctx.status = 200;
}).get("/liveness" , (ctx) => {
    ctx.status = 200;
});

app.use(router.routes());
  
if (!module.parent) app.listen(PORT);

function forwardTraceHeaders(req) {
    incoming_headers = [
        'x-request-id',
        'x-b3-traceid',
        'x-b3-spanid',
        'x-b3-parentspanid',
        'x-b3-sampled',
        'x-b3-flags',
        'x-ot-span-context',
        'x-dev-user'
    ]
    const headers = {};
    for (let h of incoming_headers) {
        if (req.header(h))
            headers[h] = req.header(h);
    }
    return headers;
}