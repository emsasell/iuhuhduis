import { createClient } from '@supabase/supabase-js';
export default async function handler(req,res){
 if(req.method!=='POST') return res.status(405).json({error:'Method not allowed'});
 const token=(req.headers.authorization||'').replace('Bearer ','');
 const auth=createClient(process.env.NEXT_PUBLIC_SUPABASE_URL,process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,{global:{headers:{Authorization:`Bearer ${token}`}}});
 const {data:{user}}=await auth.auth.getUser(); if(!user) return res.status(401).json({error:'Unauthorized'});
 const admin=createClient(process.env.NEXT_PUBLIC_SUPABASE_URL,process.env.SUPABASE_SERVICE_ROLE_KEY);
 const {data:me}=await admin.from('profiles').select('role').eq('id',user.id).single();
 if(!me || !['admin','owner'].includes(me.role)) return res.status(403).json({error:'Forbidden'});
 const {action,target_id,verified,banned,role}=req.body||{};
 if(action==='update_user'){
   const patch={}; if(typeof verified==='boolean') patch.verified=verified; if(typeof banned==='boolean') patch.banned=banned;
   if(role && me.role==='owner') patch.role=role;
   const {data,error}=await admin.from('profiles').update(patch).eq('id',target_id).select().single(); if(error) return res.status(400).json({error:error.message});
   await admin.from('admin_logs').insert({actor_id:user.id,action:'update_user',target_id,details:patch}); return res.json({user:data});
 }
 const {data,error}=await admin.from('profiles').select('*').order('created_at',{ascending:false}).limit(100); if(error)return res.status(400).json({error:error.message}); return res.json({users:data});
}
