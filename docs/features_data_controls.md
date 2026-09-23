# Comprehensive Documentation for `data_controls`

**Path:** `lib/features/data_controls/`

## Files

### 📄 `data_table_widget.dart`
**Key Imports:**
- `import '../../core/utils/ui_helpers.dart';`

**Defined Types & Details:**

#### `AdvancedDataTable` <T> extends StatefulWidget
- **Fields / Properties:**
  - `data`
  - `columns`
  - `searchHint`
  - `pageSizes`
  - `showBulkActions`
- **Methods:**
  - `createState()`

#### `_AdvancedDataTableState` <T> extends State<AdvancedDataTable<T>>
- **Fields / Properties:**
  - `_currentPage`
  - `_pageSize`
  - `_searchQuery`
  - `_sortColumnIndex`
  - `_sortAscending`
  - `_selectedRows`
  - `_filteredData`
  - `start`
  - `i`
  - `item`
- **Methods:**
  - `initState()`
  - `_applyFilters()`
  - `didUpdateWidget()`
  - `_toggleSelectAll()`
  - `setState()`
  - `dispose()`
  - `build()`
  - `_pageButton()`
  - `_emptyState()`

#### `DataColumnDef` <T>
- **Fields / Properties:**
  - `key`
  - `label`
  - `sortable`
  - `visible`

#### `ListSorting` <T> on List<T>
- **Fields / Properties:**
  - `sorted`
- **Methods:**
  - `advancedSort()`

#### `DateRangeFilter` 
- **Fields / Properties:**
  - `start`
  - `end`
  - `true`
- **Methods:**
  - `DateRangeFilter()`
  - `apply()`

#### `FilterSet` 
- **Fields / Properties:**
  - `searchQuery`
  - `sortField`
  - `sortAscending`

---

