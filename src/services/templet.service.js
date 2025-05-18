const fs = require('fs');
const path = './data/templates.json';

function readTemplates() {
  return JSON.parse(fs.readFileSync(path, 'utf-8'));
}

function writeTemplates(data) {
  fs.writeFileSync(path, JSON.stringify(data, null, 2));
}

exports.getAllTemplates = () => readTemplates();

exports.addTemplate = (template) => {
  const data = readTemplates();
  template.id = Date.now().toString();
  data.push(template);
  writeTemplates(data);
  return { success: true };
};

exports.updateTemplate = (id, updated) => {
  let data = readTemplates();
  const index = data.findIndex(t => t.id === id);
  if (index === -1) return { success: false };
  data[index] = { ...data[index], ...updated };
  writeTemplates(data);
  return { success: true };
};

exports.deleteTemplate = (id) => {
  let data = readTemplates().filter(t => t.id !== id);
  writeTemplates(data);
  return { success: true };
};
