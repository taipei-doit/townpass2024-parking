import type { Spot } from '@/views/SurroundingServiceView.vue';

// 定義一個輔助函數來動態解析路徑
export const getNestedValue = (obj: any, path: string): any => {
  return path.split('.').reduce((acc, part) => {
    const match = part.match(/(\w+)\[(\d+)\]/);
    if (match) {
      return acc && acc[match[1]] ? acc[match[1]][parseInt(match[2], 10)] : undefined;
    }
    return acc ? acc[part] : undefined;
  }, obj);
};

export const mappingFormatter = (item: any, formatFields: any, serviceInfos?: any[]): Spot => {
  const mapServiceInfo = (serviceInfo: any) => {
    if (serviceInfo.value_fields) {
      return {
        title: serviceInfo.title,
        value_fields: serviceInfo.value_fields.map((field: any) => ({
          title: field.title,
          value: getNestedValue(item, field.value_field)
        }))
      };
    } else {
      return {
        title: serviceInfo.title,
        value: getNestedValue(item, serviceInfo.value_field)
      };
    }
  };

  return {
    id: getNestedValue(item, formatFields.id),
    name: getNestedValue(item, formatFields.name),
    area: getNestedValue(item, formatFields.area),
    address: getNestedValue(item, formatFields.address),
    lat: parseFloat(getNestedValue(item, formatFields.lat) || 0),
    lng: parseFloat(getNestedValue(item, formatFields.lng) || 0),
    serviceInfos: serviceInfos?.flatMap(mapServiceInfo),
    ...item
  };
};
