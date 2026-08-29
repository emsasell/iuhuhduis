export default function handler(req,res){
  res.setHeader('Cache-Control','public, max-age=300');
  res.status(200).json({
    SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL || '',
    SUPABASE_ANON_KEY: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || ''
  });
}
