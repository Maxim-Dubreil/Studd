<template>
  <component :is="iconComponent" :class="classes" v-bind="$attrs" />
</template>

<script setup lang="ts">
import { computed } from "vue";
import {
  useStyleUtils,
  type SizeVariant,
} from "../../composables/useStyleUtils";

// Import des icônes Lucide
import {
  Home,
  Grid3X3,
  BookOpen,
  Calendar,
  FileText,
  Clock,
  CheckCircle,
  FolderOpen,
  Users,
  Settings,
  Bell,
  Search,
  Plus,
  Trash2,
  Edit,
  MoreHorizontal,
  ArrowRight,
  Download,
  Upload,
  Star,
  Heart,
  Mail,
  Phone,
  MapPin,
  Tag,
  Bookmark,
  Share,
  Copy,
  RefreshCw,
  AlertCircle,
  Info,
  CheckCircle2,
  XCircle,
  Shield,
  Lock,
  Unlock,
  Eye,
  EyeOff,
  Play,
  Pause,
  SkipForward,
  SkipBack,
  Volume2,
  VolumeX,
  Mic,
  MicOff,
  Camera,
  Image,
  Video,
  Link,
  ExternalLink,
  Menu,
  X,
  ChevronDown,
  ChevronUp,
  ChevronLeft,
  ChevronRight,
  ChevronsLeft,
  ChevronsRight,
  ChevronsUp,
  ChevronsDown,
  ArrowUp,
  ArrowDown,
  ArrowLeft,
  TrendingUp,
  TrendingDown,
  BarChart3,
  PieChart,
  Activity,
  Zap,
  Target,
  Award,
  Briefcase,
  GraduationCap,
  BookMarked,
  Lightbulb,
  Coffee,
  Palette,
  Code,
  Database,
  Server,
  Globe,
  Wifi,
  WifiOff,
  Battery,
  BatteryLow,
  Bluetooth,
  Smartphone,
  Laptop,
  Monitor,
  Printer,
  Mouse,
  Keyboard,
  Headphones,
  Gamepad2,
  Moon,
  Sun,
} from "lucide-vue-next";

interface Props {
  name: string;
  size?: SizeVariant;
  color?: string;
}

const props = withDefaults(defineProps<Props>(), {
  size: "md",
  color: "text-current",
});

const { getIconClasses } = useStyleUtils();

const classes = computed(() => getIconClasses.value(props.size, props.color));

// Mapping des noms d'icônes vers les composants Lucide
const iconMap = {
  // Navigation
  home: Home,
  grid: Grid3X3,
  calendar: Calendar,
  book: BookOpen,
  document: FileText,
  folder: FolderOpen,

  // Actions
  clock: Clock,
  check: CheckCircle,
  check2: CheckCircle2,
  users: Users,
  settings: Settings,
  bell: Bell,
  search: Search,
  plus: Plus,
  trash: Trash2,
  edit: Edit,
  more: MoreHorizontal,
  arrow: ArrowRight,
  download: Download,
  upload: Upload,

  // Social
  star: Star,
  heart: Heart,
  mail: Mail,
  phone: Phone,
  location: MapPin,
  tag: Tag,
  bookmark: Bookmark,
  share: Share,
  copy: Copy,
  refresh: RefreshCw,

  // Status
  alert: AlertCircle,
  info: Info,
  success: CheckCircle2,
  error: XCircle,
  shield: Shield,
  lock: Lock,
  unlock: Unlock,
  eye: Eye,
  eyeOff: EyeOff,

  // Media
  play: Play,
  pause: Pause,
  skipForward: SkipForward,
  skipBack: SkipBack,
  volume: Volume2,
  volumeOff: VolumeX,
  mic: Mic,
  micOff: MicOff,
  camera: Camera,
  image: Image,
  video: Video,

  // Links
  link: Link,
  externalLink: ExternalLink,

  // UI
  menu: Menu,
  close: X,
  chevronDown: ChevronDown,
  chevronUp: ChevronUp,
  chevronLeft: ChevronLeft,
  chevronRight: ChevronRight,
  chevronsLeft: ChevronsLeft,
  chevronsRight: ChevronsRight,
  chevronsUp: ChevronsUp,
  chevronsDown: ChevronsDown,
  arrowUp: ArrowUp,
  arrowDown: ArrowDown,
  arrowLeft: ArrowLeft,

  // Analytics
  trendingUp: TrendingUp,
  trendingDown: TrendingDown,
  barChart: BarChart3,
  pieChart: PieChart,
  activity: Activity,
  zap: Zap,
  target: Target,
  award: Award,

  // Education
  briefcase: Briefcase,
  graduation: GraduationCap,
  bookmarked: BookMarked,
  lightbulb: Lightbulb,
  coffee: Coffee,
  palette: Palette,

  // Tech
  code: Code,
  database: Database,
  server: Server,
  globe: Globe,
  wifi: Wifi,
  wifiOff: WifiOff,
  battery: Battery,
  batteryLow: BatteryLow,
  bluetooth: Bluetooth,

  // Devices
  smartphone: Smartphone,
  laptop: Laptop,
  monitor: Monitor,
  printer: Printer,
  mouse: Mouse,
  keyboard: Keyboard,
  headphones: Headphones,
  gamepad: Gamepad2,

  // Theme
  moon: Moon,
  sun: Sun,
};

const iconComponent = computed(() => {
  const icon = iconMap[props.name as keyof typeof iconMap];
  if (!icon) {
    console.warn(
      `Icon "${props.name}" not found. Available icons:`,
      Object.keys(iconMap)
    );
    return Home; // Icône par défaut
  }
  return icon;
});
</script>
