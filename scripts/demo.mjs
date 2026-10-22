import fs from 'node:fs';
import path from 'node:path';
import {spawnSync} from 'node:child_process';
import {getDb,REPO_ROOT} from './lib/db.mjs';
import {migrate} from './migrate.mjs';
import {seed} from './seed.mjs';
process.env.DATABASE_URL='';process.env.DATA_DIR=path.join(REPO_ROOT,'.data/demo');process.env.OUTPUT_DIR=path.join(REPO_ROOT,'.data/demo-output');
const db=await getDb();try{await migrate(db);await seed(db);}finally{await db.close();}
for(const args of [['scripts/spaces.mjs','space-review'],['scripts/spaces.mjs','move-readiness'],['scripts/spaces.mjs','attention'],['scripts/view.mjs'],['scripts/docs.mjs']]){const p=spawnSync(process.execPath,args,{cwd:REPO_ROOT,env:process.env,encoding:'utf8'});if(p.status!==0)throw Error(p.stderr||'Demo command failed');console.log(p.stdout.trim());if(args[0].endsWith('spaces.mjs')){const dir=path.join(process.env.OUTPUT_DIR,'captures');fs.mkdirSync(dir,{recursive:true});fs.writeFileSync(path.join(dir,args[1]+'.txt'),p.stdout);}}
console.log('Demo records and output are fictional and isolated under .data.');
