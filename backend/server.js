const Koa = require('koa');
const logger = require('koa-logger');
const router = require('koa-router')();
const app = module.exports = new Koa();

const PORT = process.env.PORT || 3000
const SERVICE_NAME = process.env.SERVICE_NAME || 'foo'
const VERSION = process.env.VERSION || 'v1'

// middleware
app.use(logger());

// route definitions
router.get('/',  async (ctx) => { 
    ctx.body = `backend-${SERVICE_NAME}:${VERSION}`;
}).get("/readiness", (ctx) => {
    ctx.status = 200;
}).get("/liveness" , (ctx) => {
    ctx.status = 200;
});

app.use(router.routes());
  
if (!module.parent) app.listen(PORT);