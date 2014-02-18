angular.module('openproject.services')

.service('WorkPackageService', ['$http', 'PathHelper', function($http, PathHelper){
  WorkPackageService = {
    getWorkPackages: function(projectId, query) {
      var url = projectId ? PathHelper.projectWorkPackagesPath(projectId) : PathHelper.workPackagesPath();

      var params =  {
        'c[]': query.selectedColumns.map(function(column){
          return column.name;
        }),
        'group_by': query.group_by
      };

      return WorkPackageService.doQuery(url, params);
    },

    loadWorkPackageColumnData: function(workPackages, columnName) {
      var url = PathHelper.workPackagesColumnDataPath();

      var params = {
        'ids[]': workPackages.map(function(workPackage){
          return workPackage.id;
        }),
        column_name: columnName
      };

      return WorkPackageService.doQuery(url, params);
    },

    augmentWorkPackagesWithColumnData: function(workPackages, columnName) {
      return WorkPackageService.loadWorkPackageColumnData(workPackages, columnName)
        .then(function(columnData){
          angular.forEach(workPackages, function(workPackage, index) {
            workPackage[columnName] = columnData[index];
          });

          return workPackages;
        });
    },

    doQuery: function(url, params) {
      return $http({
        method: 'GET',
        url: url,
        params: params,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'
      }}).then(function(response){
        return response.data;
      });
    }
  };

  return WorkPackageService;
}]);
