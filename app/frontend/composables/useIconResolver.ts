import droitImg from '@/images/Droit.png';
import physiqueImg from '@/images/Physique.png';
import adnImg from '@/images/adn.png';
import atomeImg from '@/images/atome.png';
import ecoImg from '@/images/eco.png';
import electroniqueImg from '@/images/electronique.png';
import geoImg from '@/images/geo.png';
import justiceImg from '@/images/justice.png';
import mathImg from '@/images/math.png';
import mechaImg from '@/images/mecha.png';
import medecineImg from '@/images/medecine.png';

const imageMap: Record<string, string> = {
  'mecha.png': mechaImg,
  'medecine.png': medecineImg,
  'eco.png': ecoImg,
  'Droit.png': droitImg,
  'Physique.png': physiqueImg,
  'adn.png': adnImg,
  'atome.png': atomeImg,
  'math.png': mathImg,
  'electronique.png': electroniqueImg,
  'justice.png': justiceImg,
  'geo.png': geoImg,
};

export function useIconResolver() {
  const getIconUrl = (path: string) => {
    return imageMap[path] || '';
  };

  return { getIconUrl };
}
