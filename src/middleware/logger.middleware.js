// Simple API logging middleware
const loggerMiddleware = (req, res, next) => {
  const startTime = Date.now();
  const timestamp = new Date().toISOString();
  
  // Log incoming request
  console.log(`\n📥 [${timestamp}] ${req.method} ${req.originalUrl}`);
  console.log(`   IP: ${req.ip || req.connection.remoteAddress || 'unknown'}`);
  console.log(`   User-Agent: ${req.get('User-Agent') || 'unknown'}`);
  
  // Log request body for POST/PUT/PATCH
  if (['POST', 'PUT', 'PATCH'].includes(req.method) && req.body) {
    console.log(`   Body: ${JSON.stringify(req.body)}`);
  }
  
  // Override res.end to capture response
  const originalEnd = res.end;
  const originalSend = res.send;
  const originalJson = res.json;
  
  let responseBody = '';
  
  res.send = function(data) {
    responseBody = data;
    return originalSend.call(this, data);
  };
  
  res.json = function(data) {
    responseBody = JSON.stringify(data);
    return originalJson.call(this, data);
  };
  
  res.end = function(chunk, encoding) {
    if (chunk) {
      responseBody += chunk;
    }
    
    const endTime = Date.now();
    const responseTime = endTime - startTime;
    const statusColor = res.statusCode >= 200 && res.statusCode < 300 ? '✅' : 
                       res.statusCode >= 400 && res.statusCode < 500 ? '⚠️' : '❌';
    
    // Log response
    console.log(`📤 [${timestamp}] ${statusColor} ${req.method} ${req.originalUrl} - ${res.statusCode} (${responseTime}ms)`);
    
    if (responseBody && responseBody.length < 200) {
      console.log(`   Response: ${responseBody}`);
    }
    
    console.log(''); // Empty line for readability
    
    return originalEnd.call(this, chunk, encoding);
  };
  
  next();
};

// Simple error logger
const errorLogger = (err, req, res, next) => {
  const timestamp = new Date().toISOString();
  
  console.log(`\n❌ [${timestamp}] ERROR in ${req.method} ${req.originalUrl}`);
  console.log(`   Error: ${err.message}`);
  console.log(`   Stack: ${err.stack}`);
  console.log('');
  
  next(err);
};

module.exports = {
  loggerMiddleware,
  errorLogger
}; 