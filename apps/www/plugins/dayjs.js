import dayjs from 'dayjs'
import relativeTime from 'dayjs/plugin/relativeTime'
import localizedFormat from 'dayjs/plugin/localizedFormat'
import 'dayjs/locale/fr'

dayjs.locale('fr')
dayjs.extend(relativeTime)
dayjs.extend(localizedFormat)
